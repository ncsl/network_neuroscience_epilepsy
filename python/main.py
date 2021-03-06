from eztrack import *

from sklearn.decomposition import PCA

# To run conversion of data from .edf files to numpy and csv files
def run_convert(patient, datadir, outputdir):
    edffilepath = os.path.join(datadir, 'edf', patient + '_0001.edf')
    convertfilepath = os.path.join(datadir, 'numpy', patient) + '/'

    if not os.path.exists(convertfilepath):
        os.makedirs(convertfilepath)

    # 1. convert data into usable format
    converter = EDFConverter(edffilepath)
    converter.edfrawtonumpy(convertmfilepath+patient+'_rawnpy.npy')
    converter.edfmetatocsv(convertfilepath+patient+'_headers.csv', \
                        convertfilepath+patient+'_chans.csv', \
                        convertfilepath+patient+'_annotations.csv')

    print edffilepath

def run_coherence(patient, datadir, outputdir, numwins=None):
    patieeg = PatientIEEG(patient)

    pat_id, seiz_id = splitpatient(patient)
    included_indices = returnindices(pat_id, seiz_id)

    # power model parameters and saved file name
    winsize = 2.5
    stepsize = 1.
    freqband = 'gamma'
    pwrfilename = os.path.join(outputdir, patient + '_' + freqband + '_adjpwr.hdf')

    # SVD parameters and saved filename
    svdfilename = os.path.join(outputdir, patient + '_' + freqband + '_svd.hdf')

    # set the file paths of the raw data
    numpyfile = os.path.join(datadir, 'numpy', patient) + '/' + patient+'_rawnpy.npy'
    chansfile = os.path.join(datadir, 'numpy', patient) + '/' + patient+'_chans.csv'
    headersfile = os.path.join(datadir, 'numpy', patient) + '/' + patient+'_headers.csv'
    annotationsfile = os.path.join(datadir, 'numpy', patient) + '/' + patient+'_annotations.csv'

    # set meta data
    patieeg.setchannels(chansfile)
    patieeg.setmetadata(headersfile)
    patieeg.setannotations(annotationsfile)

    # load raw data
    rawdata = patieeg.loadrawdata(numpyfile)
    rawdata = rawdata[included_indices,:]

    # get dimensions of raw data
    numchans, numsamps = rawdata.shape

    # filter data
    rawdata = patieeg.filterrawdata(rawdata, filttype='notch')
    rawdata = notchfilt(rawdata, patieeg.samplefreq.values)

    # run coherence model
    coherencemodel = CoherenceModel(winsize=2.5, stepsize=1., recordduration=patieeg.recordduration.values, samplerate=patieeg.samplefreq.values, freqbands=freqband)
    coherence_mats, timepoints = coherencemodel.run_model(rawdata, patieeg, numwins=numwins)

    # save the A matrix
    with h5py.File(pwrfilename, 'w') as outfile:
        dataset = outfile.create_dataset('adjpwr', data=coherence_mats)
        times_set = outfile.create_dataset('timepoints', data=timepoints)
        metadata = outfile.create_dataset('metadata', data=h5py.Empty("f"))

        # set attributes
        dataset.attrs['winsize'] = winsize
        dataset.attrs['stepsize'] = stepsize
        dataset.attrs['freqband'] = freqband
        dataset.attrs['freqrange'] = coherencemodel.freqbands
        
        # set metadata
        metadata.attrs["samplerate"] = patieeg.samplefreq.values
        metadata.attrs["recordduration"] = patieeg.recordduration.values
        metadata.attrs['onset_time'] = patieeg.onset_time.values
        metadata.attrs['offset_time'] = patieeg.offset_time.values

    print coherence_mats.shape
    print timepoints.shape
    print "Finished coherence model now running SVD!"

    # run svd decomposition
    svdU = coherencemodel.run_svd(coherence_mats)

    # save the SVD matrices
    with h5py.File(svdfilename, 'w') as outfile:
        dataset = outfile.create_dataset('svdu', data=svdU)
        times_set = outfile.create_dataset('timepoints', data=timepoints)
        metadata = outfile.create_dataset('metadata', data=h5py.Empty("f"))

        # set attributes
        dataset.attrs['winsize'] = winsize
        dataset.attrs['stepsize'] = stepsize
        dataset.attrs['freqband'] = freqband
        dataset.attrs['freqrange'] = coherencemodel.freqbands

        # set metadata
        metadata.attrs["samplerate"] = patieeg.samplefreq.values
        metadata.attrs["recordduration"] = patieeg.recordduration.values
        metadata.attrs['onset_time'] = patieeg.onset_time.values
        metadata.attrs['offset_time'] = patieeg.offset_time.values


    print svdU.shape
    print "Finished power coherence and svd!"

def run_pca(patient, datadir, outputdir):
    patieeg = PatientIEEG(patient)

    pat_id, seiz_id = splitpatient(patient)
    included_indices = returnindices(pat_id, seiz_id)
    winsize = 2.5
    stepsize = 1.
    freqband = 'gamma'

    # meta data
    chansfile = os.path.join(datadir, 'numpy', patient) + '/' + patient+'_chans.csv'
    headersfile = os.path.join(datadir, 'numpy', patient) + '/' + patient+'_headers.csv'
    annotationsfile = os.path.join(datadir, 'numpy', patient) + '/' + patient+'_annotations.csv'

    # set meta data
    patieeg.setchannels(chansfile)
    patieeg.setmetadata(headersfile)
    patieeg.setannotations(annotationsfile)

    # SVD parameters and saved filename
    svdfilename = os.path.join(outputdir, patient + '_' + freqband + '_svd.hdf')

    with h5py.File(svdfilename, 'r') as infile:
        # extract datasets
        svd_dataset = infile['svdu']
        timepoints_dataset = infile['timepoints']

        svdu = svd_dataset[...]
        timepoints = timepoints_dataset[...]
    
        metadata = dict()
        for attr in svd_dataset.attrs:
            metadata[str(attr)] = svd_dataset.attrs[attr]

    # get the first singular vectors only and format as chans X wins
    evcmat = svdu[:,:,0].squeeze().T

    # initialize PCA model
    evcmodel = EVCModel(winsize=winsize, stepsize=stepsize, \
        samplerate=patieeg.samplefreq.values, freqbands=freqband)
    area_mat = evcmodel.run_evc(evcmat)

    print area_mat.shape
    print "Finished normalizing ranked EVC!"

    ## next needs to run PCA to convert rankedEVC of channels -> PCA space
    ## and store score 

    pca = PCA(n_components=2)
    pcamat = pca.fit_transform(area_mat.T)
    # x,y = transf[:,0], transf[:,1]



if __name__ == "__main__":
    print "running eztrack!"
    patient='pt1sz2'
    numwins = None

    # data directory
    datadir = '../data'

    # output directory for data and results
    outputdir = './output'

    # run_convert(patient, datadir, outputdir)

    # run_coherence(patient, datadir, outputdir, numwins)

    run_pca(patient, datadir, outputdir)

    print "finished!"
function patient_info = load_patient_info()

eztrack_home = [getenv('HOME') '/dev/eztrack'];
patient_info = load([eztrack_home '/data/patient_info.mat']);

end


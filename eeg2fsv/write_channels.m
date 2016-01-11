function write_channels(channels_directory, file)
%WRITE_CHANNELS Write a 1 x n cell array of channel labels to file as csv.

% TODO: Test the channels in the channels_directory using filter_channels.
%       The existing interface to filter_channels will change...that was just 
%       temporarily put in place for testing.
% channels = filter_channels(channels_directory);

% For now, channels is just stubbed out with fake data:
fake_data = {'LPT100';'LPT101';'LPT102';'LPT103';'LPT104';'LPT105';'LPT106';'LPT107';'LPT108';'LPT109';
 'LPT10';'LPT110';'LPT111';'LPT112';'LPT113';'LPT114';'LPT115';'LPT116';'LPT117';'LPT118';
 'LPT119';'LPT11';'LPT120';'LPT121';'LPT122';'LPT123';'LPT124';'LPT125';'LPT126';'LPT127';
 'LPT128';'LPT12';'LPT13';'LPT14';'LPT15';'LPT16';'LPT17';'LPT18';'LPT19';'LPT1';'LPT20';
 'LPT21';'LPT22';'LPT23';'LPT24';'LPT25';'LPT26';'LPT27';'LPT28';'LPT29';'LPT2';'LPT30';
 'LPT31';'LPT32';'LPT33';'LPT34';'LPT35';'LPT36';'LPT37';'LPT38';'LPT39';'LPT3';'LPT40';
 'LPT41';'LPT42';'LPT43';'LPT44';'LPT45';'LPT46';'LPT47';'LPT48';'LPT49';'LPT4';'LPT50';
 'LPT51';'LPT52';'LPT53';'LPT54';'LPT55';'LPT56';'LPT57';'LPT58';'LPT59';'LPT5';'LPT60';
 'LPT61';'LPT62';'LPT63';'LPT64';'LPT65';'LPT66';'LPT67';'LPT68';'LPT69';'LPT6';'LPT70';
 'LPT71';'LPT72';'LPT73';'LPT74';'LPT75';'LPT76';'LPT77';'LPT78';'LPT79';'LPT7';'LPT80';
 'LPT81';'LPT82';'LPT83';'LPT84';'LPT85';'LPT86';'LPT87';'LPT88';'LPT89';'LPT8';'LPT90';
 'LPT91';'LPT92';'LPT93';'LPT94';'LPT95';'LPT96';'LPT97';'LPT98';'LPT99';'LPT9'};

channels = cell(1, size(fake_data,1));
channels(1,:) = fake_data;

ds = cell2dataset(channels);
export(ds,'file',file,'delimiter',',');

display(sprintf('Wrote csv of filtered channel labels to %s',file));

end


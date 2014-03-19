%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% NAME: precip_main.m
%% PROJECT: Bias-Corrected Spatial Disaggregation
%% AUTHOR: Yugarshi Mondal
%% DESCRIPTION: This script bias corrects lgm and midHolocene GCM preciptitation records.
%% INPUTS: - none -
%% OUTPUTS: - none -
%%
%% HISTORY:
%% YM 06/04/2013 -- Created

function arcgridwrite(fileName,Z,boxBorder)

	obsDef = loadObsDef();
	runNum = boxBorder(1,1);
	dummy = boxBorder(1,2:5); boxBorder = dummy;
	lats = [boxBorder(1)*obsDef.deltaLat+obsDef.zeroLat:obsDef.deltaLat:boxBorder(2)*obsDef.deltaLat+obsDef.zeroLat];
	lons = [boxBorder(3)*obsDef.deltaLon+obsDef.zeroLon:obsDef.deltaLon:boxBorder(4)*obsDef.deltaLon+obsDef.zeroLon];

	%replace NaNs with NODATA value 
	Z(isnan(Z))=-9999;
	Z=fliplr(Z);

	%define precision of output file
	dc = 4;
	dc=['%.',sprintf('%d',dc),'f'];

	fid=fopen(fileName,'wt');

	%write header
	mz = size(Z,1); nz= size(Z,2);
	fprintf(fid,'%s\t','ncols');
	fprintf(fid,'%d\n',nz);
	fprintf(fid,'%s\t','nrows');
	fprintf(fid,'%d\n',mz);
	fprintf(fid,'%s\t','xllcorner');
	fprintf(fid,[dc,'\n'],min(lats));
	fprintf(fid,'%s\t','yllcorner');
	fprintf(fid,[dc,'\n'],min(lons));
	fprintf(fid,'%s\t','cellsize');
	fprintf(fid,[dc,'\n'],obsDef.deltaLat);
	fprintf(fid,'%s\t','NODATA_value');
	fprintf(fid,[dc,'\n'],-9999);

	%configure filename and path
	%[pname,fname,ext] = fileparts(fileName);
	%if isempty(pname)==1;
	%    pname=pwd;
	%end

	%if strcmpi(pname(end),filesep)~=1
	%    pname=[pname,filesep];
	%end


	test=repmat([dc,'\t'],1,nz); 
	test(end-1:end)='\n'; 
	%write data 
	for i=mz:-1:1 
		fprintf(fid,test,Z(i,:)); 
	end 


	%close(h)
	fclose(fid);

end

%  Must run genlgftkern  FIRST to have the kernels
% Example:    cq = logft(vsc32, 512,  kerncos, kernsin,  windsizmax, nfreqs);
% NB: kernels + windsizmax and nfreqs have been returned by running genlgftkern
%  returns rows of length nfreqs

function  [cq, time]  = logft_dct2(infile, hopsiz, ker_dct2, windsizmax, nfreqs, SR)

[nrows ncols] = size(infile);

if ncols ~= 1 & nrows ~= 1
   error('infile not a row or col array');
elseif ncols ~= 1
   infile = infile';
end

% fprintf('logft: windsizmax= %.0f= %.1f ms  ;     nfreqs = %.0f \n', windsizmax,1000*windsizmax/SR,   nfreqs);
[nr nc] = size(ker_dct2);
if nc < windsizmax
	windsizmax = nc;
	fprintf('logft: NOTE: winsizmax longer than need for this minfreq; changing to %.0f = %.1f ms(freq=%.0f)\n', nc, 1000*nc/SR, SR/nc);
end
nhops = 1 + floor((length(infile)-windsizmax)/hopsiz) ;
cq = zeros(nfreqs, nhops);

    for jj = 0:nhops-1
	 	ninit = jj*hopsiz+1;
 		nfnl  =  jj*hopsiz +1 + windsizmax - 1;
		infile2 = infile(ninit:nfnl);      
        xk_dct2= ker_dct2*infile2;
        cq(:,jj+1)=xk_dct2; % no square here
    end
    cq = cq';
    [rowcq collcq] = size(cq);
    time = (hopsiz / SR )  * [1 : rowcq] ;
 
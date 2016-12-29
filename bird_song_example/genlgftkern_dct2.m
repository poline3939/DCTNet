% % Example:   [kerncos, kernsin, freqs ] =  genlgftkern(174.6141, 1.0293022366 , 11025, 120, 1102);
%
% nfreqs and windsizmax optional but must input 0 if not a value
% 	will choose 100 ms max and nfreqs up to Nyq
% minfreq =  440/(2^(1/12))^16 ; % F3  174.6141     G3 = 195.9977
% nfreqs  = 60;
% freqrat = 2^(1/12);  % 2^(1/24) = 1.0293022366
% SR = 11025 ;
% windsizmax = fix(.1 * SR);  % take a 100 ms max

function [ker_dct2,freqs]=genlgftkern_dct2(minfreq,freqrat,SR,nfreqs,windsizmax,winnam,constwind)
% Put these steps back in if want to run this prog indep of logftS
% if (nargin < 5 | windsizmax == 0)   %  no input windsizmax
%if windsizmax == 0
%	windsizmax = floor( .1 * SR);  % take a 100 ms max
%	fprintf('No input maximum window size. Taking 100 ms max.\n');
%end
% if (nargin < 4 | nfreqs == 0)   % no nfreqs either
%if nfreqs == 0
%   nfreqs = fix( log(SR/(2*minfreq))/log(freqrat) ); % to give highest freq at the Nyq
%	fprintf('No input number of freqs; taking freqs from minfreq to Nyquist = %.0f freq bins\n', nfreqs);
%end

% winnam = 'hamming';
% if ~exist('winnam'), winnam = 'hamming';
% %     fprintf('Using default window Hamming\n');
% else fprintf('Input window %s \n', winnam);
% end  
if winnam(1:4) == 'rect', winnam = 'boxcar'; end
    
Q = 1/(freqrat - 1);
TWOPI = 2*pi;
mindigfreq = TWOPI * minfreq / SR;
freqs = minfreq * (freqrat .^ [(0:1:nfreqs-1)]);
pos = find(freqs < SR/2);
freqs = freqs(pos);
nfreqs = length(freqs);
digfreq =  freqs * TWOPI/SR;
	% shouldn't need the following since fixed up freqs
if sum(find(digfreq > pi)) ~= 0, error('freq over Nyq'); end

flag = 1;
% if constwind == 0
    windsizOk = fix (TWOPI*Q ./digfreq);  % period in samples time Q
    % arg = (pi/2) * ones(nfreqs, windsiz);
    windsizmax;
    windsizOk(1);
    if (windsizmax >  windsizOk(1)),
        windsizmax = windsizOk(1);
        flag = 0;  
    end
    pos = find(windsizOk > windsizmax);
    % if windsizmax < windsizOk(1) so get some windows not as long as necess for that Q
    if (flag)
%         fprintf('genlgftkern: Const window %.0f up to freq position %.0f and frequency %.0f out of %.0f frequencies. windsizMinfreq = %.0f Q=%.1f\n', ...
%             windsizmax, max(pos), digfreq(max(pos)) * SR/(2*pi), length(digfreq), windsizOk(1), Q);
    else
        fprintf('genlgftkern: No const window; windsizmax = %.0f = windsizMinfreq = %.0f Q=%.1f\n', ...
            windsizmax,  windsizOk(1), Q);
    end
%     fprintf('\n');          
    windsizOk(pos) = windsizmax;
    
%     kerncos = zeros(nfreqs, windsizOk(1) );
%     kernsin = zeros(nfreqs, windsizOk(1) );
    ker_dct2= zeros(nfreqs, windsizOk(1) );
    
    numzeros = windsizOk(1) - windsizOk;
    numzerosO2 = round(numzeros/2);
% else
%      kerncos = zeros(nfreqs, constwind );
%     kernsin = zeros(nfreqs, constwind );
% end

% Get kaiser number if window is kaiser
           if length(winnam) > 5   
              if   winnam(1:6) == 'kaiser'
                if length(winnam) == 7, kaiserno = winnam(7); 
                elseif length(winnam) == 8, kaiserno = winnam(7:8); 
                else kaiserno = '8'; % default is 8 for no input kaiser number
                end
                winnam = 'kaiser';   
              end
            end
           
  if constwind == 0,
      for k = 1:nfreqs
          sz = windsizOk(k);
          switch(winnam)
          case 'kaiser'
              winstr = [ winnam '(' num2str(sz) ',' kaiserno ')'];
          otherwise
              winstr = [ winnam '(' num2str(sz) ')'];
          end
          % fprintf(' calc window %s \n', winstr);
          wind = eval(winstr); 
          wind = wind';
          
          %        wind = boxcar(windsizOk(k))'; 
          numz = 1;
          if numzerosO2(k) ~= 0, numz =  numzerosO2(k); end;
          ker_dct2(k, numz: numz + windsizOk(k)-1) = (1/windsizOk(k)) * ...
              cos(digfreq(k)*(-sz/2+1/2 : sz/2 - 1+1/2 )).* wind;
%           kerncos(k, numz: numz + windsizOk(k)-1) = (1/windsizOk(k)) * ...
%                cos(digfreq(k)*( -sz/2 : sz/2 - 1 )).* wind;
%            %   cos(digfreq(k)*(0:windsizOk(k)-1)).* wind;
%           
          %		    cos(digfreq(k)*(0:windsizOk(k)-1)).* wind((1:windsizOk(k)));
%           kernsin(k, numz: numz + windsizOk(k)-1) = (1/windsizOk(k)) * ...
%                     sin(digfreq(k)*( ( -sz/2+1/2 : sz/2 - 1+1/2 )).* wind;
%           %    sin(digfreq(k)*(0:windsizOk(k)-1)).* wind;
%           %		    sin(digfreq(k)*(0:windsizOk(k)-1)).* wind((1:windsizOk(k)));
      end
  end
  
  % fprintf('nfreqs = %.0f ;    windsizmax = %.0f \n',nfreqs, windsizmax);
  
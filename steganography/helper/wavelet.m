function varargout = wavelet(WaveletName,Level,X,Ext,Dim)
%WAVELET  Discrete wavelet transform. 
%   Y = WAVELET(W,L,X) computes the L-stage discrete wavelet transform 
%   (DWT) of signal X using wavelet W.  The length of X must be 
%   divisible by 2^L.  For the inverse transform, WAVELET(W,-L,X) 
%   inverts L stages.  Choices for W are 
%     'Haar'                                      Haar 
%     'D1','D2','D3','D4','D5','D6'               Daubechies' 
%     'Sym1','Sym2','Sym3','Sym4','Sym5','Sym6'   Symlets 
%     'Coif1','Coif2'                             Coiflets 
%     'BCoif1'                                    Coiflet-like [2] 
%     'Spline Nr.Nd' (or 'bior Nr.Nd') for        Splines 
%       Nr = 0,  Nd = 0,1,2,3,4,5,6,7, or 8 
%       Nr = 1,  Nd = 0,1,3,5, or 7 
%       Nr = 2,  Nd = 0,1,2,4,6, or 8 
%       Nr = 3,  Nd = 0,1,3,5, or 7 
%       Nr = 4,  Nd = 0,1,2,4,6, or 8 
%       Nr = 5,  Nd = 0,1,3, or 5 
%     'RSpline Nr.Nd' for the same Nr.Nd pairs    Reverse splines¤Ï¦±½u 
%     'S+P (2,2)','S+P (4,2)','S+P (6,2)',        S+P wavelets [3] 
%     'S+P (4,4)','S+P (2+2,2)' 
%     'TT'                                        "Two-Ten" [5] 
%     'LC 5/3','LC 2/6','LC 9/7-M','LC 2/10',     Low Complexity [1] 
%     'LC 5/11-C','LC 5/11-A','LC 6/14', 
%     'LC 13/7-T','LC 13/7-C' 
%     'Le Gall 5/3','CDF 9/7'                     JPEG2000 [7] 
%     'V9/3'                                      Visual [8] 
%     'Lazy'                                      Lazy wavelet 
%   Case and spaces are ignored in wavelet names, for example, 'Sym4' 
%   may also be written as 'sym 4'.  Some wavelets have multiple names, 
%   'D1', 'Sym1', and 'Spline 1.1' are aliases of the Haar wavelet. 
% 
%   WAVELET(W) displays information about wavelet W and plots the 
%   primal and dual scaling and wavelet functions. 
% 
%   For 2D transforms, prefix W with '2D'.  For example, '2D S+P (2,2)' 
%   specifies a 2D (tensor) transform with the S+P (2,2) wavelet. 
%   2D transforms require that X is either MxN or MxNxP where M and N 
%   are divisible by 2^L. 
% 
%   WAVELET(W,L,X,EXT) specifies boundary handling EXT.  Choices are 
%     'sym'      Symmetric extension (same as 'wsws') 
%     'asym'     Antisymmetric extension, whole-point antisymmetry 
%     'zpd'      Zero-padding 
%     'per'      Periodic extension 
%     'sp0'      Constant extrapolation 
% 
%   Various symmetric extensions are supported: 
%     'wsws'     Whole-point symmetry (WS) on both boundaries 
%     'hshs'     Half-point symmetry (HS) on both boundaries 
%     'wshs'     WS left boundary, HS right boundary 
%     'hsws'     HS left boundary, WS right boundary 
% 
%   Antisymmetric boundary handling is used by default, EXT = 'asym'. 
% 
%   WAVELET(...,DIM) operates along dimension DIM. 
% 
%   [H1,G1,H2,G2] = WAVELET(W,'filters') returns the filters 
%   associated with wavelet transform W.  Each filter is represented 
%   by a cell array where the first cell contains an array of 
%   coefficients and the second cell contains a scalar of the leading 
%   Z-power. 
% 
%   [X,PHI1] = WAVELET(W,'phi1') returns an approximation of the 
%   scaling function associated with wavelet transform W. 
%   [X,PHI1] = WAVELET(W,'phi1',N) approximates the scaling function 
%   with resolution 2^-N.  Similarly, 
%   [X,PSI1] = WAVELET(W,'psi1',...), 
%   [X,PHI2] = WAVELET(W,'phi2',...), 
%   and [X,PSI2] = WAVELET(W,'psi2',...) return approximations of the 
%   wavelet function, dual scaling function, and dual wavelet function. 
% 
%   Wavelet transforms are implemented using the lifting scheme [4]. 
%   For general background on wavelets, see for example [6]. 
% 
% 
%   Examples: 
%   % Display information about the S+P (4,4) wavelet 
%   wavelet('S+P (4,4)'); 
% 
%   % Plot a wavelet decomposition 
%   t = linspace(0,1,256); 
%   X = exp(-t) + sqrt(t - 0.3).*(t > 0.3) - 0.2*(t > 0.6); 
%   wavelet('RSpline 3.1',3,X);        % Plot the decomposition of X 
% 
%   % Sym4 with periodic boundaries 
%   Y = wavelet('Sym4',5,X,'per');    % Forward transform with 5 stages 
%   R = wavelet('Sym4',-5,Y,'per');   % Invert 5 stages 
% 
%   % 2D transform on an image 
%   t = linspace(-1,1,128); [x,y] = meshgrid(t,t); 
%   X = ((x+1).*(x-1) - (y+1).*(y-1)) + real(sqrt(0.4 - x.^2 - y.^2)); 
%   Y = wavelet('2D CDF 9/7',2,X);    % 2D wavelet transform 
%   R = wavelet('2D CDF 9/7',-2,Y);   % Recover X from Y 
%   imagesc(abs(Y).^0.2); colormap(gray); axis image; 
% 
%   % Plot the Daubechies 2 scaling function 
%   [x,phi] = wavelet('D2','phi'); 
%   plot(x,phi); 
% 
%   References: 
%   [1] M. Adams and F. Kossentini.  "Reversible Integer-to-Integer 
%       Wavelet Transforms for Image Compression."  IEEE Trans. on 
%       Image Proc., vol. 9, no. 6, Jun. 2000. 
% 
%   [2] M. Antonini, M. Barlaud, P. Mathieu, and I. Daubechies.  "Image 
%       Coding using Wavelet Transforms."  IEEE Trans. Image Processing, 
%       vol. 1, pp. 205-220, 1992. 
% 
%   [3] R. Calderbank, I. Daubechies, W. Sweldens, and Boon-Lock Yeo. 
%       "Lossless Image Compression using Integer to Integer Wavelet 
%       Transforms."  ICIP IEEE Press, vol. 1, pp. 596-599.  1997. 
% 
%   [4] I. Daubechies and W. Sweldens.  "Factoring Wavelet Transforms 
%       into Lifting Steps."  1996. 
% 
%   [5] D. Le Gall and A. Tabatabai.  "Subband Coding of Digital Images 
%       Using Symmetric Short Kernel Filters and Arithmetic Coding 
%       Techniques."  ICASSP'88, pp.761-765, 1988. 
% 
%   [6] S. Mallat.  "A Wavelet Tour of Signal Processing."  Academic 
%       Press, 1999. 
% 
%   [7] M. Unser and T. Blu.  "Mathematical Properties of the JPEG2000 
%       Wavelet Filters." IEEE Trans. on Image Proc., vol. 12, no. 9, 
%       Sep. 2003. 
% 
%   [8] Qinghai Wang and Yulong Mo.  "Choice of Wavelet Base in 
%       JPEG2000."  Computer Engineering, vol. 30, no. 23, Dec. 2004. 
 
% Pascal Getreuer 2005-2006 
 
if nargin < 1, error('Not enough input arguments.'); end 
if ~ischar(WaveletName), error('Invalid wavelet name.'); end 
 
% Get a lifting scheme sequence for the specified wavelet 
Flag1D = isempty(findstr(lower(WaveletName),'2d')); 
[Seq,ScaleS,ScaleD,Family] = getwavelet(WaveletName); 
 
if isempty(Seq) 
   error(['Unknown wavelet, ''',WaveletName,'''.']); 
end 
 
if nargin < 2, Level = ''; end 
if ischar(Level) 
   [h1,g1] = seq2hg(Seq,ScaleS,ScaleD,0); 
   [h2,g2] = seq2hg(Seq,ScaleS,ScaleD,1); 
 
   if strcmpi(Level,'filters') 
      varargout = {h1,g1,h2,g2}; 
   else 
      if nargin < 3, X = 6; end 
 
      switch lower(Level) 
      case {'phi1','phi'} 
         [x1,phi] = cascade(h1,g1,pow2(-X)); 
         varargout = {x1,phi}; 
      case {'psi1','psi'} 
         [x1,phi,x2,psi] = cascade(h1,g1,pow2(-X)); 
         varargout = {x2,psi}; 
      case 'phi2' 
         [x1,phi] = cascade(h2,g2,pow2(-X)); 
         varargout = {x1,phi}; 
      case 'psi2' 
         [x1,phi,x2,psi] = cascade(h2,g2,pow2(-X)); 
         varargout = {x2,psi}; 
      case '' 
         fprintf('\n%s wavelet ''%s'' ',Family,WaveletName); 
 
         if all(abs([norm(h1{1}),norm(h2{1})] - 1) < 1e-11) 
            fprintf('(orthogonal)\n'); 
         else 
            fprintf('(biorthogonal)\n'); 
         end 
          
         fprintf('Vanishing moments: %d analysis, %d reconstruction\n',... 
            numvanish(g1{1}),numvanish(g2{1})); 
         fprintf('Filter lengths: %d/%d-tap\n',... 
            length(h1{1}),length(g1{1}));          
         fprintf('Implementation lifting steps: %d\n\n',... 
            size(Seq,1)-all([Seq{1,:}] == 0)); 
          
         fprintf('h1(z) = %s\n',filterstr(h1,ScaleS)); 
         fprintf('g1(z) = %s\n',filterstr(g1,ScaleD)); 
         fprintf('h2(z) = %s\n',filterstr(h2,1/ScaleS)); 
         fprintf('g2(z) = %s\n\n',filterstr(g2,1/ScaleD)); 
 
         [x1,phi,x2,psi] = cascade(h1,g1,pow2(-X)); 
         subplot(2,2,1); 
         plot(x1,phi,'b-'); 
         if diff(x1([1,end])) > 0, xlim(x1([1,end])); end 
         title('\phi_1'); 
         subplot(2,2,3); 
         plot(x2,psi,'b-'); 
         if diff(x2([1,end])) > 0, xlim(x2([1,end])); end 
         title('\psi_1'); 
         [x1,phi,x2,psi] = cascade(h2,g2,pow2(-X)); 
         subplot(2,2,2); 
         plot(x1,phi,'b-'); 
         if diff(x1([1,end])) > 0, xlim(x1([1,end])); end 
         title('\phi_2'); 
         subplot(2,2,4); 
         plot(x2,psi,'b-'); 
         if diff(x2([1,end])) > 0, xlim(x2([1,end])); end 
         title('\psi_2'); 
         set(gcf,'NextPlot','replacechildren'); 
      otherwise 
         error(['Invalid parameter, ''',Level,'''.']); 
      end 
   end 
 
   return; 
elseif nargin < 5 
   % Use antisymmetric extension by default 
   if nargin < 4 
      if nargin < 3, error('Not enough input arguments.'); end 
 
      Ext = 'asym'; 
   end 
 
   Dim = min(find(size(X) ~= 1)); 
   if isempty(Dim), Dim = 1; end 
end 
 
if any(size(Level) ~= 1), error('Invalid decomposition level.'); end 
 
NumStages = size(Seq,1); 
EvenStages = ~rem(NumStages,2); 
 
if Flag1D   % 1D Transfrom 
   %%% Convert N-D array to a 2-D array with dimension Dim along the columns %%% 
   XSize = size(X);    % Save original dimensions 
   N = XSize(Dim); 
   M = prod(XSize)/N; 
   Perm = [Dim:max(length(XSize),Dim),1:Dim-1]; 
   X = double(reshape(permute(X,Perm),N,M)); 
 
   if M == 1 & nargout == 0 & Level > 0 
      % Create a figure of the wavelet decomposition 
      set(gcf,'NextPlot','replace'); 
      subplot(Level+2,1,1); 
      plot(X); 
      title('Wavelet Decomposition'); 
      axis tight; axis off; 
 
      X = feval(mfilename,WaveletName,Level,X,Ext,1); 
 
      for i = 1:Level 
         N2 = N; 
         N = 0.5*N; 
         subplot(Level+2,1,i+1); 
         a = max(abs(X(N+1:N2)))*1.1; 
         plot(N+1:N2,X(N+1:N2),'b-'); 
         ylabel(['d',sprintf('_%c',num2str(i))]); 
         axis([N+1,N2,-a,a]); 
      end 
 
      subplot(Level+2,1,Level+2); 
      plot(X(1:N),'-'); 
      xlabel('Coefficient Index'); 
      ylabel('s_1'); 
      axis tight; 
      set(gcf,'NextPlot','replacechildren'); 
      varargout = {X}; 
      return; 
   end 
 
   if rem(N,pow2(abs(Level))), error('Signal length must be divisible by 2^L.'); end 
   if N < pow2(abs(Level)), error('Signal length too small for transform level.'); end 
 
   if Level >= 0           % Forward transform 
      for i = 1:Level 
         Xo = X(2:2:N,:); 
         Xe = X(1:2:N,:) + xfir(Seq{1,1},Seq{1,2},Xo,Ext); 
 
         for k = 3:2:NumStages 
            Xo = Xo + xfir(Seq{k-1,1},Seq{k-1,2},Xe,Ext); 
            Xe = Xe + xfir(Seq{k,1},Seq{k,2},Xo,Ext); 
         end 
 
         if EvenStages 
            Xo = Xo + xfir(Seq{NumStages,1},Seq{NumStages,2},Xe,Ext); 
         end 
 
         X(1:N,:) = [Xe*ScaleS; Xo*ScaleD]; 
         N = 0.5*N; 
      end 
   else                     % Inverse transform 
      N = N * pow2(Level); 
 
      for i = 1:-Level 
         N2 = 2*N; 
         Xe = X(1:N,:)/ScaleS; 
         Xo = X(N+1:N2,:)/ScaleD; 
 
         if EvenStages 
            Xo = Xo - xfir(Seq{NumStages,1},Seq{NumStages,2},Xe,Ext); 
         end 
 
         for k = NumStages - EvenStages:-2:3 
            Xe = Xe - xfir(Seq{k,1},Seq{k,2},Xo,Ext); 
            Xo = Xo - xfir(Seq{k-1,1},Seq{k-1,2},Xe,Ext); 
         end 
 
         X([1:2:N2,2:2:N2],:) = [Xe - xfir(Seq{1,1},Seq{1,2},Xo,Ext); Xo]; 
         N = N2; 
      end 
   end 
 
   X = ipermute(reshape(X,XSize(Perm)),Perm);   % Restore original array dimensions 
else        % 2D Transfrom 
   N = size(X); 
 
   if length(N) > 3 | any(rem(N([1,2]),pow2(abs(Level)))) 
      error('Input size must be either MxN or MxNxP where M and N are divisible by 2^L.'); 
   end 
 
   if Level >= 0   % 2D Forward transform 
      for i = 1:Level 
         Xo = X(2:2:N(1),1:N(2),:); 
         Xe = X(1:2:N(1),1:N(2),:) + xfir(Seq{1,1},Seq{1,2},Xo,Ext); 
 
         for k = 3:2:NumStages 
            Xo = Xo + xfir(Seq{k-1,1},Seq{k-1,2},Xe,Ext); 
            Xe = Xe + xfir(Seq{k,1},Seq{k,2},Xo,Ext); 
         end 
 
         if EvenStages 
            Xo = Xo + xfir(Seq{NumStages,1},Seq{NumStages,2},Xe,Ext); 
         end 
 
         X(1:N(1),1:N(2),:) = [Xe*ScaleS; Xo*ScaleD]; 
          
         Xo = permute(X(1:N(1),2:2:N(2),:),[2,1,3]); 
         Xe = permute(X(1:N(1),1:2:N(2),:),[2,1,3]) ... 
            + xfir(Seq{1,1},Seq{1,2},Xo,Ext); 
 
         for k = 3:2:NumStages 
            Xo = Xo + xfir(Seq{k-1,1},Seq{k-1,2},Xe,Ext); 
            Xe = Xe + xfir(Seq{k,1},Seq{k,2},Xo,Ext); 
         end 
 
         if EvenStages 
            Xo = Xo + xfir(Seq{NumStages,1},Seq{NumStages,2},Xe,Ext); 
         end 
          
         X(1:N(1),1:N(2),:) = [permute(Xe,[2,1,3])*ScaleS,... 
               permute(Xo,[2,1,3])*ScaleD]; 
         N = 0.5*N; 
      end 
   else           % 2D Inverse transform 
      N = N*pow2(Level); 
 
      for i = 1:-Level 
         N2 = 2*N; 
         Xe = permute(X(1:N2(1),1:N(2),:),[2,1,3])/ScaleS; 
         Xo = permute(X(1:N2(1),N(2)+1:N2(2),:),[2,1,3])/ScaleD; 
 
         if EvenStages 
            Xo = Xo - xfir(Seq{NumStages,1},Seq{NumStages,2},Xe,Ext); 
         end 
 
         for k = NumStages - EvenStages:-2:3 
            Xe = Xe - xfir(Seq{k,1},Seq{k,2},Xo,Ext); 
            Xo = Xo - xfir(Seq{k-1,1},Seq{k-1,2},Xe,Ext); 
         end 
          
         X(1:N2(1),[1:2:N2(2),2:2:N2(2)],:) = ... 
            [permute(Xe - xfir(Seq{1,1},Seq{1,2},Xo,Ext),[2,1,3]), ... 
               permute(Xo,[2,1,3])]; 
          
         Xe = X(1:N(1),1:N2(2),:)/ScaleS; 
         Xo = X(N(1)+1:N2(1),1:N2(2),:)/ScaleD; 
 
         if EvenStages 
            Xo = Xo - xfir(Seq{NumStages,1},Seq{NumStages,2},Xe,Ext); 
         end 
 
         for k = NumStages - EvenStages:-2:3 
            Xe = Xe - xfir(Seq{k,1},Seq{k,2},Xo,Ext); 
            Xo = Xo - xfir(Seq{k-1,1},Seq{k-1,2},Xe,Ext); 
         end 
          
         X([1:2:N2(1),2:2:N2(1)],1:N2(2),:) = ... 
            [Xe - xfir(Seq{1,1},Seq{1,2},Xo,Ext); Xo]; 
         N = N2; 
      end 
   end 
end 
 
varargout{1} = X; 
return; 
 
 
function [Seq,ScaleS,ScaleD,Family] = getwavelet(WaveletName) 
%GETWAVELET   Get wavelet lifting scheme sequence. 
% Pascal Getreuer 2005-2006 
 
WaveletName = strrep(WaveletName,'bior','spline'); 
ScaleS = 1/sqrt(2); 
ScaleD = 1/sqrt(2); 
Family = 'Spline'; 
 
switch strrep(strrep(lower(WaveletName),'2d',''),' ','') 
case {'haar','d1','db1','sym1','spline1.1','rspline1.1'} 
   Seq = {1,0;-0.5,0}; 
   ScaleD = -sqrt(2); 
   Family = 'Haar'; 
case {'d2','db2','sym2'} 
   Seq = {sqrt(3),0;[-sqrt(3),2-sqrt(3)]/4,0;-1,1}; 
   ScaleS = (sqrt(3)-1)/sqrt(2); 
   ScaleD = (sqrt(3)+1)/sqrt(2); 
   Family = 'Daubechies'; 
case {'d3','db3','sym3'} 
   Seq = {2.4254972439123361,0;[-0.3523876576801823,0.0793394561587384],0; 
      [0.5614149091879961,-2.8953474543648969],2;-0.0197505292372931,-2}; 
   ScaleS = 0.4318799914853075; 
   ScaleD = 2.3154580432421348; 
   Family = 'Daubechies'; 
case {'d4','db4'} 
   Seq = {0.3222758879971411,-1;[0.3001422587485443,1.1171236051605939],1; 
      [-0.1176480867984784,0.0188083527262439],-1; 
      [-0.6364282711906594,-2.1318167127552199],1; 
      [0.0247912381571950,-0.1400392377326117,0.4690834789110281],2};    
   ScaleS = 1.3621667200737697; 
   ScaleD = 0.7341245276832514; 
   Family = 'Daubechies'; 
case {'d5','db5'} 
   Seq = {0.2651451428113514,-1;[-0.2477292913288009,-0.9940591341382633],1; 
      [-0.2132742982207803,0.5341246460905558],1; 
      [0.7168557197126235,-0.2247352231444452],-1; 
      [-0.0121321866213973,0.0775533344610336],3;0.035764924629411,-3};    
   ScaleS = 1.3101844387211246; 
   ScaleD = 0.7632513182465389; 
   Family = 'Daubechies'; 
case {'d6','db6'} 
   Seq = {4.4344683000391223,0;[-0.214593449940913,0.0633131925095066],0; 
      [4.4931131753641633,-9.970015617571832],2; 
      [-0.0574139367993266,0.0236634936395882],-2; 
      [0.6787843541162683,-2.3564970162896977],4; 
      [-0.0071835631074942,0.0009911655293238],-4;-0.0941066741175849,5};    
   ScaleS = 0.3203624223883869; 
   ScaleD = 3.1214647228121661; 
   Family = 'Daubechies'; 
case 'sym4' 
   Seq = {-0.3911469419700402,0;[0.3392439918649451,0.1243902829333865],0; 
      [-0.1620314520393038,1.4195148522334731],1; 
      -[0.1459830772565225,0.4312834159749964],1;1.049255198049293,-1};    
   ScaleS = 0.6366587855802818; 
   ScaleD = 1.5707000714496564; 
   Family = 'Symlet'; 
case 'sym5' 
   Seq = {0.9259329171294208,0;-[0.1319230270282341,0.4985231842281166],1; 
      [1.452118924420613,0.4293261204657586],0; 
      [-0.2804023843755281,0.0948300395515551],0; 
      -[0.7680659387165244,1.9589167118877153],1;0.1726400850543451,0}; 
   ScaleS = 0.4914339446751972; 
   ScaleD = 2.0348614718930915; 
   Family = 'Symlet'; 
case 'sym6' 
   Seq = {-0.2266091476053614,0;[0.2155407618197651,-1.2670686037583443],0; 
      [-4.2551584226048398,0.5047757263881194],2; 
      [0.2331599353469357,0.0447459687134724],-2; 
      [6.6244572505007815,-18.389000853969371],4; 
      [-0.0567684937266291,0.1443950619899142],-4;-5.5119344180654508,5}; 
   ScaleS = -0.5985483742581210; 
   ScaleD = -1.6707087396895259; 
   Family = 'Symlet'; 
case 'coif1' 
   Seq = {-4.6457513110481772,0;[0.205718913884,0.1171567416519999],0; 
      [0.6076252184992341,-7.468626966435207],2;-0.0728756555332089,-2};    
   ScaleS = -0.5818609561112537; 
   ScaleD = -1.7186236496830642; 
   Family = 'Coiflet'; 
case 'coif2' 
   Seq = {-2.5303036209828274,0;[0.3418203790296641,-0.2401406244344829],0; 
      [15.268378737252995,3.1631993897610227],2; 
      [-0.0646171619180252,0.005717132970962],-2; 
      [13.59117256930759,-63.95104824798802],4; 
      [-0.0018667030862775,0.0005087264425263],-4;-3.7930423341992774,5}; 
   ScaleS = 0.1076673102965570; 
   ScaleD = 9.2878701738310099; 
   Family = 'Coiflet'; 
case 'bcoif1' 
   Seq = {0,0;-[1,1]/5,1;[5,5]/14,0;-[21,21]/100,1}; 
   ScaleS = sqrt(2)*7/10; 
   ScaleD = sqrt(2)*5/7; 
   Family = 'Nearly orthonormal Coiflet-like'; 
case {'lazy','spline0.0','rspline0.0','d0'} 
   Seq = {0,0}; 
   ScaleS = 1; 
   ScaleD = 1; 
   Family = 'Lazy'; 
case {'spline0.1','rspline0.1'} 
   Seq = {1,-1}; 
   ScaleD = 1; 
case {'spline0.2','rspline0.2'} 
   Seq = {[1,1]/2,0}; 
   ScaleD = 1; 
case {'spline0.3','rspline0.3'} 
   Seq = {[-1,6,3]/8,1}; 
   ScaleD = 1; 
case {'spline0.4','rspline0.4'} 
   Seq = {[-1,9,9,-1]/16,1}; 
   ScaleD = 1; 
case {'spline0.5','rspline0.5'} 
   Seq = {[3,-20,90,60,-5]/128,2};    
   ScaleD = 1; 
case {'spline0.6','rspline0.6'} 
   Seq = {[3,-25,150,150,-25,3]/256,2};    
   ScaleD = 1; 
case {'spline0.7','rspline0.7'} 
   Seq = {[-5,42,-175,700,525,-70,7]/1024,3};   
   ScaleD = 1; 
case {'spline0.8','rspline0.8'} 
   Seq = {[-5,49,-245,1225,1225,-245,49,-5]/2048,3}; 
   ScaleD = 1; 
case {'spline1.0','rspline1.0'} 
   Seq = {0,0;-1,0}; 
   ScaleS = sqrt(2); 
   ScaleD = -1/sqrt(2);    
case {'spline1.3','rspline1.3'} 
   Seq = {0,0;-1,0;[-1,8,1]/16,1}; 
   ScaleS = sqrt(2); 
   ScaleD = -1/sqrt(2); 
case {'spline1.5','rspline1.5'} 
   Seq = {0,0;-1,0;[3,-22,128,22,-3]/256,2}; 
   ScaleS = sqrt(2); 
   ScaleD = -1/sqrt(2); 
case {'spline1.7','rspline1.7'} 
   Seq = {0,0;-1,0;[-5,44,-201,1024,201,-44,5]/2048,3};    
   ScaleS = sqrt(2); 
   ScaleD = -1/sqrt(2); 
case {'spline2.0','rspline2.0'} 
   Seq = {0,0;-[1,1]/2,1}; 
   ScaleS = sqrt(2); 
   ScaleD = 1; 
case {'spline2.1','rspline2.1'} 
   Seq = {0,0;-[1,1]/2,1;0.5,0}; 
   ScaleS = sqrt(2); 
case {'spline2.2','rspline2.2','cdf5/3','legall5/3','s+p(2,2)','lc5/3'} 
   Seq = {0,0;-[1,1]/2,1;[1,1]/4,0}; 
   ScaleS = sqrt(2); 
case {'spline2.4','rspline2.4'} 
   Seq = {0,0;-[1,1]/2,1;[-3,19,19,-3]/64,1}; 
   ScaleS = sqrt(2); 
case {'spline2.6','rspline2.6'} 
   Seq = {0,0;-[1,1]/2,1;[5,-39,162,162,-39,5]/512,2}; 
   ScaleS = sqrt(2); 
case {'spline2.8','rspline2.8'} 
   Seq = {0,0;-[1,1]/2,1;[-35,335,-1563,5359,5359,-1563,335,-35]/16384,3}; 
   ScaleS = sqrt(2); 
case {'spline3.0','rspline3.0'} 
   Seq = {-1/3,-1;-[3,9]/8,1};    
   ScaleS = 3/sqrt(2); 
   ScaleD = 2/3; 
case {'spline3.1','rspline3.1'} 
   Seq = {-1/3,-1;-[3,9]/8,1;4/9,0}; 
   ScaleS = 3/sqrt(2); 
   ScaleD = -2/3; 
case {'spline3.3','rspline3.3'} 
   Seq = {-1/3,-1;-[3,9]/8,1;[-3,16,3]/36,1}; 
   ScaleS = 3/sqrt(2); 
   ScaleD = -2/3; 
case {'spline3.5','rspline3.5'} 
   Seq = {-1/3,-1;-[3,9]/8,1;[5,-34,128,34,-5]/288,2}; 
   ScaleS = 3/sqrt(2); 
   ScaleD = -2/3; 
case {'spline3.7','rspline3.7'} 
   Seq = {-1/3,-1;-[3,9]/8,1;[-35,300,-1263,4096,1263,-300,35]/9216,3}; 
   ScaleS = 3/sqrt(2); 
   ScaleD = -2/3; 
case {'spline4.0','rspline4.0'} 
   Seq = {-[1,1]/4,0;-[1,1],1}; 
   ScaleS = 4/sqrt(2); 
   ScaleD = 1/sqrt(2); 
   %ScaleS = 1; ScaleD = 1; 
case {'spline4.1','rspline4.1'} 
   Seq = {-[1,1]/4,0;-[1,1],1;6/16,0}; 
   ScaleS = 4/sqrt(2); 
   ScaleD = 1/2; 
case {'spline4.2','rspline4.2'} 
   Seq = {-[1,1]/4,0;-[1,1],1;[3,3]/16,0}; 
   ScaleS = 4/sqrt(2); 
   ScaleD = 1/2; 
case {'spline4.4','rspline4.4'} 
   Seq = {-[1,1]/4,0;-[1,1],1;[-5,29,29,-5]/128,1}; 
   ScaleS = 4/sqrt(2); 
   ScaleD = 1/2; 
case {'spline4.6','rspline4.6'} 
   Seq = {-[1,1]/4,0;-[1,1],1;[35,-265,998,998,-265,35]/4096,2}; 
   ScaleS = 4/sqrt(2); 
   ScaleD = 1/2; 
case {'spline4.8','rspline4.8'} 
   Seq = {-[1,1]/4,0;-[1,1],1;[-63,595,-2687,8299,8299,-2687,595,-63]/32768,3}; 
   ScaleS = 4/sqrt(2); 
   ScaleD = 1/2; 
case {'spline5.0','rspline5.0'} 
   Seq = {0,0;-1/5,0;-[5,15]/24,0;-[9,15]/10,1};    
   ScaleS = 3*sqrt(2); 
   ScaleD = sqrt(2)/6; 
case {'spline5.1','rspline5.1'} 
   Seq = {0,0;-1/5,0;-[5,15]/24,0;-[9,15]/10,1;1/3,0}; 
   ScaleS = 3*sqrt(2); 
   ScaleD = sqrt(2)/6; 
case {'spline5.3','rspline5.3'} 
   Seq = {0,0;-1/5,0;-[5,15]/24,0;-[9,15]/10,1;[-5,24,5]/72,1}; 
   ScaleS = 3*sqrt(2); 
   ScaleD = sqrt(2)/6; 
case {'spline5.5','rspline5.5'} 
   Seq = {0,0;-1/5,0;-[5,15]/24,0;-[9,15]/10,1;[35,-230,768,230,-35]/2304,2}; 
   ScaleS = 3*sqrt(2); 
   ScaleD = sqrt(2)/6; 
case {'cdf9/7'}    
   Seq = {0,0;[1,1]*-1.5861343420693648,1;[1,1]*-0.0529801185718856,0; 
      [1,1]*0.8829110755411875,1;[1,1]*0.4435068520511142,0}; 
   ScaleS = 1.1496043988602418; 
   ScaleD = 1/ScaleS; 
   Family = 'Cohen-Daubechies-Feauveau'; 
case 'v9/3' 
   Seq = {0,0;[-1,-1]/2,1;[1,19,19,1]/80,1}; 
   ScaleS = sqrt(2); 
   Family = 'HSV design'; 
case {'s+p(4,2)','lc9/7-m'} 
   Seq = {0,0;[1,-9,-9,1]/16,2;[1,1]/4,0};    
   ScaleS = sqrt(2); 
   Family = 'S+P'; 
case 's+p(6,2)' 
   Seq = {0,0;[-3,25,-150,-150,25,-3]/256,3;[1,1]/4,0}; 
   ScaleS = sqrt(2); 
   Family = 'S+P'; 
case {'s+p(4,4)','lc13/7-t'} 
   Seq = {0,0;[1,-9,-9,1]/16,2;[-1,9,9,-1]/32,1}; 
   ScaleS = sqrt(2); 
   Family = 'S+P'; 
case {'s+p(2+2,2)','lc5/11-c'} 
   Seq = {0,0;[-1,-1]/2,1;[1,1]/4,0;-[-1,1,1,-1]/16,2}; 
   ScaleS = sqrt(2); 
   Family = 'S+P'; 
case 'tt' 
   Seq = {1,0;[3,-22,-128,22,-3]/256,2}; 
   ScaleD = sqrt(2); 
   Family = 'Le Gall-Tabatabai polynomial'; 
case 'lc2/6' 
   Seq = {0,0;-1,0;1/2,0;[-1,0,1]/4,1}; 
   ScaleS = sqrt(2); 
   ScaleD = -1/sqrt(2); 
   Family = 'Reverse spline'; 
case 'lc2/10' 
   Seq = {0,0;-1,0;1/2,0;[3,-22,0,22,-3]/64,2}; 
   ScaleS = sqrt(2); 
   ScaleD = -1/sqrt(2); 
   Family = 'Reverse spline'; 
case 'lc5/11-a' 
   Seq = {0,0;-[1,1]/2,1;[1,1]/4,0;[1,-1,-1,1]/32,2};    
   ScaleS = sqrt(2); 
   ScaleD = -1/sqrt(2); 
   Family = 'Low complexity'; 
case 'lc6/14' 
   Seq = {0,0;-1,0;[-1,8,1]/16,1;[1,-6,0,6,-1]/16,2};    
   ScaleS = sqrt(2); 
   ScaleD = -1/sqrt(2); 
   Family = 'Low complexity'; 
case 'lc13/7-c' 
   Seq = {0,0;[1,-9,-9,1]/16,2;[-1,5,5,-1]/16,1};    
   ScaleS = sqrt(2); 
   ScaleD = -1/sqrt(2); 
   Family = 'Low complexity'; 
case  'idk'
    % Added for Egypt algorithm
   Seq = {1,0;-0.5,0};
   ScaleS = 1;
   ScaleD = 50;
   Family = 'IDK';
otherwise 
   Seq = {}; 
   return; 
end 
 
if ~isempty(findstr(lower(WaveletName),'rspline')) 
   [Seq,ScaleS,ScaleD] = seqdual(Seq,ScaleS,ScaleD); 
   Family = 'Reverse spline'; 
end 
 
return; 
 
 
function [Seq,ScaleS,ScaleD] = seqdual(Seq,ScaleS,ScaleD) 
% Dual of a lifting sequence 
 
L = size(Seq,1); 
 
for k = 1:L 
   % f'(z) = -f(z^-1) 
   Seq{k,2} = -(Seq{k,2} - length(Seq{k,1}) + 1); 
   Seq{k,1} = -fliplr(Seq{k,1}); 
end 
 
if all(Seq{1,1} == 0) 
   Seq = reshape({Seq{2:end,:}},L-1,2); 
else 
   [Seq{1:L+1,:}] = deal(0,Seq{1:L,1},0,Seq{1:L,2}); 
end 
 
ScaleS = 1/ScaleS; 
ScaleD = 1/ScaleD; 
return; 
 
 
function [h,g] = seq2hg(Seq,ScaleS,ScaleD,Dual) 
% Find wavelet filters from lifting sequence 
if Dual, [Seq,ScaleS,ScaleD] = seqdual(Seq,ScaleS,ScaleD); end 
if rem(size(Seq,1),2), [Seq{size(Seq,1)+1,:}] = deal(0,0); end 
 
h = {1,0}; 
g = {1,1}; 
 
for k = 1:2:size(Seq,1) 
   h = lp_lift(h,g,{Seq{k,:}}); 
   g = lp_lift(g,h,{Seq{k+1,:}}); 
end 
 
h = {ScaleS*h{1},h{2}}; 
g = {ScaleD*g{1},g{2}}; 
 
if Dual 
   h{2} = -(h{2} - length(h{1}) + 1); 
   h{1} = fliplr(h{1}); 
 
   g{2} = -(g{2} - length(g{1}) + 1); 
   g{1} = fliplr(g{1}); 
end 
 
return; 
 
 
function a = lp_lift(a,b,c) 
% a(z) = a(z) + b(z) c(z^2) 
 
d = zeros(1,length(c{1})*2-1); 
d(1:2:end) = c{1}; 
d = conv(b{1},d); 
z = b{2}+c{2}*2; 
zmax = max(a{2},z); 
f = [zeros(1,zmax-a{2}),a{1},zeros(1,a{2} - length(a{1}) - z + length(d))]; 
i = zmax-z + (1:length(d)); 
f(i) = f(i) + d; 
 
if all(abs(f) < 1e-12) 
   a = {0,0}; 
else 
   i = find(abs(f)/max(abs(f)) > 1e-10); 
   i1 = min(i); 
   a = {f(i1:max(i)),zmax-i1+1}; 
end 
return; 
 
 
function X = xfir(B,Z,X,Ext) 
%XFIR  Noncausal FIR filtering with boundary handling. 
%   Y = XFIR(B,Z,X,EXT) filters X with FIR filter B with leading 
%   delay -Z along the columns of X.  EXT specifies the  boundary 
%   handling.  Special handling  is done for one and two-tap filters. 
 
% Pascal Getreuer 2005-2006 
 
N = size(X); 
 
% Special handling for short filters 
if length(B) == 1 & Z == 0 
   if B == 0 
      X = zeros(size(X)); 
   elseif B ~= 1 
      X = B*X; 
   end 
   return; 
end 
 
% Compute the number of samples to add to each end of the signal 
pl = max(length(B)-1-Z,0);       % Padding on the left end 
pr = max(Z,0);                   % Padding on the right end 
 
switch lower(Ext) 
case {'sym','wsws'}   % Symmetric extension, WSWS 
   if all([pl,pr] < N(1)) 
         X = filter(B,1,X([pl+1:-1:2,1:N(1),N(1)-1:-1:N(1)-pr],:,:),[],1); 
         X = X(Z+pl+1:Z+pl+N(1),:,:); 
      return; 
   else 
      i = [1:N(1),N(1)-1:-1:2]; 
      Ns = 2*N(1) - 2 + (N(1) == 1); 
      i = i([rem(pl*(Ns-1):pl*Ns-1,Ns)+1,1:N(1),rem(N(1):N(1)+pr-1,Ns)+1]); 
   end 
case {'symh','hshs'}  % Symmetric extension, HSHS 
   if all([pl,pr] < N(1)) 
      i = [pl:-1:1,1:N(1),N(1):-1:N(1)-pr+1]; 
   else 
      i = [1:N(1),N(1):-1:1]; 
      Ns = 2*N(1); 
      i = i([rem(pl*(Ns-1):pl*Ns-1,Ns)+1,1:N(1),rem(N(1):N(1)+pr-1,Ns)+1]); 
   end 
case 'wshs'           % Symmetric extension, WSHS 
   if all([pl,pr] < N(1)) 
      i = [pl+1:-1:2,1:N(1),N(1):-1:N(1)-pr+1]; 
   else 
      i = [1:N(1),N(1):-1:2]; 
      Ns = 2*N(1) - 1; 
      i = i([rem(pl*(Ns-1):pl*Ns-1,Ns)+1,1:N(1),rem(N(1):N(1)+pr-1,Ns)+1]); 
   end 
case 'hsws'           % Symmetric extension, HSWS 
   if all([pl,pr] < N(1)) 
      i = [pl:-1:1,1:N(1),N(1)-1:-1:N(1)-pr]; 
   else 
      i = [1:N(1),N(1)-1:-1:1]; 
      Ns = 2*N(1) - 1; 
      i = i([rem(pl*(Ns-1):pl*Ns-1,Ns)+1,1:N(1),rem(N(1):N(1)+pr-1,Ns)+1]); 
   end 
case 'zpd' 
   Ml = N; Ml(1) = pl; 
   Mr = N; Mr(1) = pr; 
    
   X = filter(B,1,[zeros(Ml);X;zeros(Mr)],[],1); 
   X = X(Z+pl+1:Z+pl+N(1),:,:); 
   return; 
case 'per'            % Periodic 
   i = [rem(pl*(N(1)-1):pl*N(1)-1,N(1))+1,1:N(1),rem(0:pr-1,N(1))+1]; 
case 'sp0'            % Constant extrapolation 
   i = [ones(1,pl),1:N(1),N(1)+zeros(1,pr)]; 
case 'asym'           % Asymmetric extension 
   i1 = [ones(1,pl),1:N(1),N(1)+zeros(1,pr)]; 
 
   if all([pl,pr] < N(1)) 
      i2 = [pl+1:-1:2,1:N(1),N(1)-1:-1:N(1)-pr]; 
   else 
      i2 = [1:N(1),N(1)-1:-1:2]; 
      Ns = 2*N(1) - 2 + (N(1) == 1); 
      i2 = i2([rem(pl*(Ns-1):pl*Ns-1,Ns)+1,1:N(1),rem(N(1):N(1)+pr-1,Ns)+1]); 
   end 
    
   X = filter(B,1,2*X(i1,:,:) - X(i2,:,:),[],1); 
   X = X(Z+pl+1:Z+pl+N(1),:,:); 
   return; 
otherwise 
   error(['Unknown boundary handling, ''',Ext,'''.']); 
end 
 
X = filter(B,1,X(i,:,:),[],1); 
X = X(Z+pl+1:Z+pl+N(1),:,:); 
return; 
 
 
function [x1,phi,x2,psi] = cascade(h,g,dx) 
% Wavelet cascade algorithm 
 
c = h{1}*2/sum(h{1}); 
x = 0:dx:length(c) - 1; 
x1 = x - h{2}; 
phi0 = 1 - abs(linspace(-1,1,length(x))).'; 
 
ii = []; jj = []; s = []; 
 
for k = 1:length(c) 
   xk = 2*x - (k-1); 
   i = find(xk >= 0 & xk <= length(c) - 1); 
   ii = [ii,i]; 
   jj = [jj,floor(xk(i)/dx)+1]; 
   s = [s,c(k)+zeros(size(i))]; 
end 
 
% Construct a sparse linear operator that iterates the dilation equation 
Dilation = sparse(ii,jj,s,length(x),length(x)); 
 
for N = 1:30 
   phi = Dilation*phi0; 
   if norm(phi - phi0,inf) < 1e-5, break; end 
   phi0 = phi; 
end 
 
if norm(phi) == 0 
   phi = ones(size(phi))*sqrt(2);   % Special case for Haar scaling function 
else 
   phi = phi/(norm(phi)*sqrt(dx));  % Rescale result 
end 
 
if nargout > 2 
   phi2 = phi(1:2:end);  % phi2 is approximately phi(2x) 
 
   if length(c) == 2 
      L = length(phi2); 
   else 
      L = ceil(0.5/dx); 
   end 
 
   % Construct psi from translates of phi2 
   c = g{1}; 
   psi = zeros(length(phi2)+L*(length(c)-1),1); 
   x2 = (0:length(psi)-1)*dx - g{2} - 0*h{2}/2; 
 
   for k = 1:length(c) 
      i = (1:length(phi2)) + L*(k-1); 
      psi(i) = psi(i) + c(k)*phi2; 
   end 
end 
return; 
 
 
function s = filterstr(a,K) 
% Convert a filter to a string 
 
[n,d] = rat(K/sqrt(2)); 
 
if d < 50 
   a{1} = a{1}/sqrt(2);   % Scale filter by sqrt(2) 
   s = '( '; 
else 
   s = ''; 
end 
 
Scale = [pow2(1:15),10,20,160,280,inf]; 
 
for i = 1:length(Scale) 
   if norm(round(a{1}*Scale(i))/Scale(i) - a{1},inf) < 1e-9 
      a{1} = a{1}*Scale(i);  % Scale filter by a power of 2 or 160 
      s = '( '; 
      break; 
   end 
end 
 
z = a{2}; 
LineOff = 0; 
 
for k = 1:length(a{1}) 
   v = a{1}(k); 
 
   if v ~= 0  % Only display nonzero coefficients 
      if k > 1 
         s2 = [' ',char(44-sign(v)),' ']; 
         v = abs(v); 
      else 
         s2 = ''; 
      end 
 
      s2 = sprintf('%s%g',s2,v); 
 
      if z == 1 
         s2 = sprintf('%s z',s2); 
      elseif z ~= 0 
         s2 = sprintf('%s z^%d',s2,z); 
      end 
 
      if length(s) + length(s2) > 72 + LineOff  % Wrap long lines 
         s2 = [char(10),'        ',s2]; 
         LineOff = length(s); 
      end 
 
      s = [s,s2]; 
   end 
 
   z = z - 1; 
end 
 
if s(1) == '(' 
   s = [s,' )']; 
 
   if d < 50, s = [s,' sqrt(2)']; end 
 
   if i < length(Scale) 
      s = sprintf('%s/%d',s,Scale(i)); 
   end 
end 
 
return; 
 
function N = numvanish(g) 
% Determine the number of vanishing moments from highpass filter g(z) 
 
for N = 0:length(g)-1  % Count the number of roots at z = 1 
   [g,r] = deconv(g,[1,-1]); 
   if norm(r,inf) > 1e-7, break; end 
end 
return; 
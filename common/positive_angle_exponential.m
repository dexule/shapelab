function[w] = positive_angle_exponential(z,a,varargin)
% [w] = positive_angle_exponential(z,a,{cut_bias=[]})
% 
%     The input z (vector-supported) has form r*exp(i*phi), where phi \in
%     [0,2*pi). This function returns r^(a)*exp(i*phi*a). Note that this
%     produces a branch discontinuity at phi = 2*pi. I.e., the branch cut of the
%     power function is placed on the positive real axis.
%
%     The optional input cut_bias specifies which side of the branch the
%     positive x-axis gets mapped to, and if this option is set then some small
%     tolerance leeway is given in favor of the bias. cut_bias=true means the
%     positive x-axis gets mapped to itself. cut_bais=false means the positive
%     x-axis gets mapped to the line segment z=exp(i*2*pi*a).
%
%     If cut_bias is an array, it is interpreted as a vector of boolean
%     (true=positive, false=negative) indicators determining which inputs take
%     the (+) x-axis side of the branch and which take the (-) x-axis side of
%     the branch. For inputs not on the x-axis, this indicator is irrelevant.

persistent input_parser parser
if isempty(parser)
  from labtools import input_parser

  [opt,parser] = input_parser({'cut_bias'}, {true}, [], varargin{:});
else
  parser.parse(varargin{:});
  opt = parser.Results;
end

if length(opt.cut_bias)==1
  if opt.cut_bias
    tol = 1e-14;
  else
    tol = -1e-14;
  end
else
  zflags = not(opt.cut_bias);
  tol = 0;
end

ang = mod(angle(z),2*pi);
flags = ang<-tol;
ang(flags) = ang(flags)+2*pi;
w = (abs(z)).^a.*exp(i*ang*a);

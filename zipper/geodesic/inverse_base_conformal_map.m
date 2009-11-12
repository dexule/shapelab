function[w] = inverse_base_conformal_map(z,a,varargin)
% [v,w] = inverse_base_conformal_map(z,a,{point_id=zeros(size(z)),cut_magnitude=abs(a)^2/imag(a))
%
%     Referring to [1], evaluates the inverse of the conformal mapping function
%     f_a, which is a basic building block for the `geodesic algorithm'
%     conformal mapping technique. The complex, scalar parameter is a, and the
%     (array) complex input is z. 
%
%     The optional input point_id has the same size as z and each entry takes
%     three possible values:
%     0: The point is some point in \mathbb{H}\backslash\mathbb{R}.
%     1: The point is located on \mathbb{R}
%     2: The point is located on \mathbb{R}, inside [-c,c]. (See code for
%        definition of c.)
%
%     cut_magnitude refers to what position on the x-axis the point a ends up
%     at. The default is simply what the default is in Marshall's paper.
%
%  [1]: Marshall and Rohde, "Convergence of the Zipper algorithm for conformal
%       mapping", 2006.

persistent input_schema moebius_inv zipup_at_c
if isempty(input_schema)
  from labtools import input_schema
  from shapelab.common import moebius_inverse as moebius_inv
  from shapelab.common import normal_slit_zipup as zipup_at_c
end

% Intermediate points: see [1]
b = abs(a)^2/real(a);
c = abs(a)^2/imag(a);
opt = input_schema({'point_id','cut_magnitude'}, ...
      {zeros(size(z),'int8'), c}, [],varargin{:});

assert(length(a)==1, 'Error: not coded for vector-valued parameter a');

factor = opt.cut_magnitude/c;

w = zipup_at_c(z,opt.cut_magnitude,'point_id',opt.point_id);
w = moebius_inv(w, [factor 0;-1/b 1]);

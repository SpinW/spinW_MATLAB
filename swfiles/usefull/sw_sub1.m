function out = sw_sub1(inp, varargin)
% converts symbolic variables into double by substituting 1 for every symbol
%
% out = SW_SUB1(inp, num)
%
% Input:
%
% inp   Any symbolic/double type matrix.
% num   Can be scalar or vector with the number of elements equal to the
%       number of symbolic variables in inp. If it is 'rand', random values
%       will be assigned to each symbolic variable in inp.
%
% Output:
%
% out   Double type output with the same dimensions as the input.
%
% See also SW_ALWAYS.
%

% $Name: SpinW$ ($Version: 3.1$)
% $Author: S. Tóth and S. Ward$ ($Contact: admin@spinw.org, @spinw4 on Twitter$)
% $Revision: 1591$ ($Date: 25-Apr-2019$)
% $License: GNU GENERAL PUBLIC LICENSE$

if nargin == 0
    swhelp sw_sub1
    return
end

if nargin == 1
    dnum = 1;
else
    dnum = varargin{1};
end

if isa(inp,'sym')
    
    symVar = symvar(inp);
    
    if strcmp(dnum,'rand')
        dnum = rand(1,numel(symVar));
    end
    
    if ~isempty(symVar)
        out = double(subs(inp,symVar,dnum.*ones(1,numel(symVar))));
    else
        out = double(inp);
    end
else
    out = inp;
end

end
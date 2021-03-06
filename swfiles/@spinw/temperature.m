function varargout = temperature(obj,varargin)
% get/set temperature
% 
% ### Syntax
% 
% `temperature(obj, T)`
%
% `T = temperature(obj)`
% 
% ### Description
% 
% `temperature(obj, T)` sets the temperature stored in `obj` to `T`, where
% `T` is scalar. The units of temerature is determined by the
% `spinw.unit.kB` value, default unit is Kelvin.
%  
% `T = temperature(obj)` returns the current temperature value stored in
% `obj`.
%  

% $Name: SpinW$ ($Version: 3.1$)
% $Author: S. Tóth and S. Ward$ ($Contact: admin@spinw.org, @spinw4 on Twitter$)
% $Revision: 1591$ ($Date: 25-Apr-2019$)
% $License: GNU GENERAL PUBLIC LICENSE$

if nargin == 1
    varargout{1} = obj.single_ion.T;
elseif nargin == 2
    T = varargin{1};
    if numel(T) == 1
        obj.single_ion.T = T;
    else
        error('spinw:temperature:ArraySize','Input temperature has to be scalar!');
    end
    if nargout > 0
        varargout{1} = obj;
    end
end

end
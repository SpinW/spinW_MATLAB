function obj = initfield(obj, varargin)
% initializes all subfields of the obj structure to the default values
%
% SPINW.INITFIELD(objS, {field})
%
% Input:
%
% objS      Structure to initialize.
% field     String or cell of strings that contains specific fields to
%           initialize.
%

% $Name: SpinW$ ($Version: 3.1$)
% $Author: S. Tóth and S. Ward$ ($Contact: admin@spinw.org, @spinw4 on Twitter$)
% $Revision: 1591$ ($Date: 25-Apr-2019$)
% $License: GNU GENERAL PUBLIC LICENSE$

datstruct = datastruct();
mainfield = datstruct.mainfield;
subfield  = datstruct.subfield;
defval    = datstruct.defval;

selector = true(1,numel(mainfield));

if nargin>1
    selector = ismember(mainfield,varargin{1});
end


%for ii = 1:numel(mainfield)
for ii = find(selector)
    for jj = 1:size(subfield,2)
        if ~isempty(subfield{ii,jj})
            if ~isfield(obj,mainfield{ii}) || ~isfield(eval(['obj.' mainfield{ii}]),subfield{ii,jj})
                obj.(mainfield{ii}).(subfield{ii,jj}) = defval{ii,jj};
            end
        end
    end
end

end
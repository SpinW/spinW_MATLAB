function parsed = sw_parstr(strIn)
% parses input string
%
% ### Syntax
%
% `parsed = sw_parstr(strIn)`
%
% ### Description
%
% `parsed = sw_parstr(strIn)` parses input string containing a mathematical
% expression, a linear combination of symbols with numerical prefactors.
% The numerical symbols begin with `'S'`, `'M'` or `'P'` followed by two
% letters from the set of `'xyz'` or `'P'` can be followed be a single
% letter from the `'xyz'` set. For example a valid input string is
% `'Sxx-0.33*Syy'`.
%
% ### Examples
%
% Simple test:
% ```
% >>sw_parstr('Sxx + Syy')>>
% ```
%
% ### Input Arguments
%
% `strIn`
% : String that contains a linear combination of symbols, e.g
%   `'0.1*Sxx+0.23*Syy'`.
%
% ### Output Arguments
%
% `parsed`
% : Struct type with the following fields:
%   * `type`    Cell contains the same number of elements as in the sum. Each element
%               is a vector as follows:
%     * `type{idx}(1)`    Index of type of cross section:
%       * 1 for `Sperp`,
%       * 2 for `Sab`,
%       * 3 for `Mab`,
%       * 4 for `Pab`,
%       * 5 for  `Pa`.
%     * `type{idx}(2:3)`  Index of the component:
%       * 1 for `x`,
%       * 2 for `y`,
%       * 3 for `z`.
%   * `preFact` Vector contains the values of the prefactors in the sum.
%   * `string`  Original input string.
%
% ### See Also
%
% [sw_egrid] \| [spinw.fitspec]

% $Name: SpinW$ ($Version: 3.1$)
% $Author: S. Tóth and S. Ward$ ($Contact: admin@spinw.org, @spinw4 on Twitter$)
% $Revision: 1591$ ($Date: 25-Apr-2019$)
% $License: GNU GENERAL PUBLIC LICENSE$



% parses input string
%
% parsed = SW_PARSTR(strIn)
%
% It parses input string containing linear expression of different cross
% sections in strIn.
%
% Input:
%
% 'Sperp'   convolutes the magnetic neutron scattering intensity
%           (<Sperp * Sperp> expectation value). Default.
% 'Sab'     convolutes the selected components of the spin-spin correlation
%           function. Letter a and b can be 'x', 'y' or 'z'. For example:
%           'Sxx' will convolute the xx component of the correlation
%           function with the dispersion. xyz is the standard coordinate
%           system, see online documentation of spinw.
% 'Mab'     convolutes the selected components of the spin-spin
%           correlation function. Letter a and b can be 'x', 'y' or 'z'.
%           For example: 'Sxx' will convolute the xx component of the
%           correlation function with the dispersion. The xyz coordinates
%           are in the Blume-Maleev coordinate system, see below.
% 'Pab'     convolutes the selected element of the polarisation
%           matrix. Letter a and b can be 'x', 'y' or 'z'. For example:
%           'Pyy' will convolute the yy component of the polarisation
%           matrix with the dispersion. The xyz coordinates are in the
%           Blume-Maleev coordinate system, see below.
% 'Pa'      convolutes the intensity of the simulated polarised
%           neutron scattering, with inciden polarisation of Pa. Letter a
%           can be 'x', 'y' or 'z'. For example: 'Py' will convolute the
%           scattering intensity simulated for incident polarisation Pi ||
%           y. The xyz coordinates are in the Blume-Maleev coordinate
%           system, see below.
%
% Any linear combination of the above are allowed, for example: 'Sxx+2*Syy'
% convolutes the linear combination of the xx component of the spin-spin
% correlation function and the yy component.
%
% The Blume-Maleev coordinate system is a cartesian coordinate system
% with (xBM, yBM and zBM) basis vectors as follows:
%           xBM    parallel to the momentum transfer Q,
%           yBM    perpendicular to xBM in the scattering plane,
%           zBM    perpendicular to the scattering plane.
%
% Output:
%
% parsed is struct type, contains the following fields:
% type      Cell contains as many elements as many in the sum. Each element
%           is a vector as follows:
%           type{idx}(1)    Index of type of cross section:
%                           1   Sperp,
%                           2   Sab,
%                           3   Mab,
%                           4   Pab,
%                           5   Pa.
%           type{idx}(2:3)  Index of the component:
%                           1   x,
%                           2   y,
%                           3   z.
%
% preFact   Vector contains the values of the prefactors in the sum.
% string    Original input string.
%
% Test it with:
% <a href="matlab:parsed = sw_parstr('Sxx + Syy')">parsed = sw_parstr('Sxx + Syy')</a>
%
% See also SW_EGRID, SPINW.FITSPEC.
%

if nargin == 0
    swhelp sw_parstr
    return
end

strIn0 = strIn;

if strcmp(strIn(1),'-')
    strIn = strIn(2:end);
    sign1 = -1;
else
    sign1 = 1;
end

idx1 = strfind(strIn,'+');
idx2 = strfind(strIn,'-');
[idx, sortOrder] = sort([idx1 idx2]);
idx = [idx length(strIn)+1];
signPre = [idx1*0+1 idx2*0-1];
signPre = signPre(sortOrder);
signPre = [sign1 signPre];

nTerm = numel(idx);

strS = cell(1,nTerm);

% separate different terms
strS{1} = strIn(1:(idx(1)-1));
for ii = 2:length(idx)
    strS{ii} = strIn((idx(ii-1)+1):(idx(ii)-1));
end

% extract prefactors
preFact = zeros(1,nTerm);
for ii = 1:nTerm
    idxPre = strfind(strS{ii},'*');
    temp = 1;
    if ~isempty(idxPre)
        temp = str2double(strS{ii}(1:idxPre-1));
        strS{ii} = strS{ii}(idxPre+1:end);
    end
    strS{ii} = strtok(strS{ii});
    preFact(ii) = temp*signPre(ii);
end

% convert xyz components into numerical indices
for ii = 1:nTerm
    strTemp = strS{ii};
    strS{ii} = 0;
    if (numel(strTemp)>1) || (numel(strTemp)>3)
        if strcmpi(strTemp,'Sperp')
            strS{ii} = 1;
        elseif any(strcmpi(strTemp(1),{'P' 'S' 'M'}))
            if strcmpi(strTemp(1),'P')
                strS{ii} = 4; % Pab
            elseif strcmpi(strTemp(1),'M')
                strS{ii} = 3; % Mab
            else
                strS{ii} = 2; % Sab
            end
            if numel(strTemp)==2
                if strS{ii} == 4
                    strS{ii} = 5; % Pa
                else
                    error('sw_parstr:WrongString','Wrong input string!');
                end
            end
            idxA = strcmpi(strTemp(2),{'x' 'y' 'z'});
            if any(idxA)
                strS{ii} = [strS{ii} find(idxA)];
            else
                error('sw_parstr:WrongString','Wrong input string!');
            end
            if numel(strTemp)==3
                idxB = strcmpi(strTemp(3),{'x' 'y' 'z'});
                if any(idxB)
                    strS{ii} = [strS{ii} find(idxB)];
                else
                    error('sw_parstr:WrongString','Wrong input string!');
                end
                
            end
        else
            error('sw_parstr:WrongString','Wrong input string!');
        end
    else
        error('sw_parstr:WrongString','Wrong input string!');
    end
end

parsed.type    = strS;
parsed.preFact = preFact;
parsed.string  = strIn0;

end
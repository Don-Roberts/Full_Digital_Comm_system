function states = de2bi(varargin)
%DE2BI Convert decimal numbers to binary numbers.

      d		= varargin{1};
      n		= varargin{2};
      p  	= varargin{3};
          
    if d == 0
        states = [0,0];
    elseif d == 1
        states = [0,1];
    elseif d == 2
        states = [1,0];
    elseif d == 3
        states = [1,1];

end

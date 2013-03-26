## -*- texinfo -*-
## @deftypefn {Function File} get (@var{A_obj})
## @deftypefnx {Function File} get (@var{A_obj}, @var{Property})
## 
## Return the named property @var{Property} from ann object. If @var{Property} is ommitted, return the complete property list for @var{A_obj}.
## 
## @end deftypefn

function V=get(Obj,varargin)
	if isa(Obj,'ann')
		args=varargin;
		if length(args)==0
			for ii = 1:length(fieldnames(Obj))
				str=fieldnames(Obj)(ii){:};
				V.(str)=Obj.(str);
				disp(' ');
			endfor
		else
			while length(args)
				Property=args{1,1};
				if ischar(Property)
					switch Property
					case 'NodeList'
						V = Obj.NodeList;
					case 'TrainingMethod'
						V = Obj.TrainingMethod;
					case 'alpha'
						V = Obj.alpha;
					case 'eta'
						V = Obj.eta;
					case 'lambda'
						V = Obj.lambda;
					case 'Graphics'
						V = Obj.Graphics;
					case 'W'
						V = Obj.__W;
					case 'Err'
						V = Obj.__Err;
					case 'Z'
						V = Obj.__Z;
					case 'A'
						V = Obj.__A;
					case 'Epoch'
						V = Obj.__Epoch;
					otherwise
						error('@ann\get: invalid Property supplied')
					endswitch
				else
					error('@ann\get: succeeding arguments must be Property strings.')
				endif
				args=args(1,2:end);
			endwhile
		endif
	else
		error('@ann\get: the first argument must be a ann instance.')
	endif
endfunction
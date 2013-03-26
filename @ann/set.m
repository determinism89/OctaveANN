## -*- texinfo -*-
## @deftypefn {Function File} {@var{A_obj} =} set (@var{A_obj}, var{A})
## @deftypefnx {Function File} {@var{A_obj} =} set (@var{A_obj}, var{PROPERTY}, var{VALUE}...)
## 
## Set ann object parameters. Return a new instance of the ann.
## 
## The first argument @var{Instance} must be the ann instance to modify.
## The succeding arguments must be either an ann instance or sequence of @var{PROPERTY}/@var{VALUE} pairs.
## 
## @end deftypefn

function Obj=set(Obj,varargin)
	if isa(Obj,'ann')
		if length(varargin) == 1
			if isa(varargin{1,1},'ann')
					Obj = varargin{1,1};
			elseif length(varargin{1,1})==2
				if size(varargin{1,1})==[1,2]
					Obj.state = [varargin{1,1}]';
				else
					Obj.state = varargin{1,1};
				endif
			else
				error('@ann\set: single argument must be an ann instance or state vector')
			endif
		elseif mod(length(varargin),2)==0
			args = varargin;
			while length(args)
				Property=args{1,1};
				Value=args{1,2};
				if ischar(Property)
					switch Property
					case {'dmmy'}
						Obj.dmmy = Value;
					case 'NodeList'
						Obj.NodeList = Value;
					case 'TrainingMethod'
						Obj.TrainingMethod = Value;
					case 'alpha'
						Obj.alpha = Value;
					case 'eta'
						Obj.eta = Value;
					case 'lambda'
						Obj.lambda = Value;
					case 'Graphics'
						Obj.Graphics = Value;
					case 'Epoch'
						Obj.__Epoch = Value;
					otherwise
						error('@ann\set: invalid Property supplied')
					endswitch
				else
					error('@ann\set: succeeding arguments must be Property strings.')
				endif
				args=args(1,3:end);
			endwhile
		else
			error('@ann\set: invalid number of arguments')
		endif
	else
		print_usage()
	endif
endfunction
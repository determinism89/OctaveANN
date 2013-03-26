## -*- texinfo -*-
## @deftypefn {Function File} train(@var{ANN_obj},@var{X},@var{Y},@var{GAM})
## @deftypefnx {Function File} train(@var{ANN_obj},@var{FILENAME},@var{INDX},@var{GAM})
## 
## Train an ann object given N training sets and the convergence criteria @var{GAM}.
## 
## @var{X} must be a matrix of training inputs.
## @example
## [X1 X2 ... XM]
## @end example
## 
## @var{Y} must be a vector of N training outputs.
## @example
## [Y1 Y2 ... YM]
## @end example
## @end deftypefn

function Obj = train(Obj,varargin)
	if ~isa(Obj,'ann')
		print_usage();
	endif
	if length(varargin)
		if ischar(varargin{1,1})
			if isnumeric(varargin{1,2}) && isnumeric(varargin{1,3})
				if ~(size(varargin{1,2}) == [1,2] || size(varargin{1,2}) == [2,1])
					error('@ann\train: INDX must be a vector of 2 dimensions.')
				endif
			else
				error('@ann\train: must include INDX arguments')
			endif
		elseif isnumeric(varargin{1,1}) && islogical(varargin{1,2})
			if (size(varargin{1,1},1) == Obj.nodelist(1)) && (size(varargin{1,2},1) == Obj.nodelist(end))
				if ~(size(varargin{1,1},2) == size(varargin{1,2},2))
					error('@ann\train: incompatible X and Y values; must have the same number of X and Y vectors.')
				endif
			else
				error('@ann\train: arguments incongruent with the ANN object called; vector arguments are of the wrong dimension.')
			endif
		else
			error('@ann\train: incorrect arguments; X must be numeric and Y must be logical as this is a classification algorithm.')
		endif
	else
		print_usage();
	endif
	
	%select training method
	switch Obj.TrainingMethod
	case "Batch"
		Obj = train_batch(Obj,varargin{:});
	case "Stochastic"
		Obj = train_stochastic(Obj,varargin{:});
	otherwise
		error('@ann\train: verify the TrainingMethod')
	endswitch
endfunction
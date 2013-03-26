## -*- texinfo -*-
## @deftypefn {Function File} test(@var{ANN_obj},@var{X},@var{Y})
## 
## Test an ann object given N training sets and the convergence criteria @var{GAM}.
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

function t = test(Obj,varargin)
	if ~isa(Obj,'ann')
		print_usage();
	endif
	if length(varargin)
		if isnumeric(varargin{1,1}) && islogical(varargin{1,2})
			X = varargin{1,1};
			Y = varargin{1,2};
			if (size(X,1) == Obj.nodelist(1)) && (size(Y,1) == Obj.nodelist(end))
				if size(X,2) == size(Y,2)
					m = size(X,2);
				else
					error('@ann\test: incompatible X and Y values; must have the same number of X and Y vectors.')
				endif
			else
				error('@ann\test: Arguments incongruent with the ANN object called; vector arguments are of the wrong dimension.')
			endif
		else
			error('@ann\test: incorrect arguments; X must be numeric and Y must be logical as this is a classification algorithm.')
		endif
	else
		print_usage();
	endif

	Obj.__A{1} = X;
	Obj.__Y = Y;

	%Forward Propogate the node values
	Obj.__Z{2} = [Obj.__W{1}]*Obj.__A{1} + Obj.__B{1}*ones(1,m);
	Obj.__A{2} = [h(Obj.__Z{2},Obj.eta)];
	for l = [2:(Obj.__NumLayers-1)]
		Obj.__Z{l+1} = [Obj.__W{l}]*[Obj.__A{l}] + Obj.__B{l} * ones(1,m);
		Obj.__A{l+1} = [h(Obj.__Z{l+1},Obj.eta)];
	endfor
	
	%evaluation criteria below is specific to digit recognition and has no bearing on how the network backpropogates. See error and cost functions for convergence data.
	
	t.list = (round(Obj.__A{end})==Obj.__Y);
	t.percentage = 10 * sum(sum(t.list))/m;
endfunction
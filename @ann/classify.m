## -*- texinfo -*-
## @deftypefn {Function File} classify(@var{ANN_obj},@var{X})
## 
## Classify a dataset using a given @var{ANN} object.
## 
## Outputs a string of digit estimates for the Kaggle Digit recognition exercise based on largest output value.

function Predictions = classify(Obj,X)
	if ~isa(Obj,'ann')
		print_usage();
	endif
	m = size(X,2);
	Obj.__A{1} = X;

	%Forward Propogate the node values
	Obj.__Z{2} = [Obj.__W{1}]*Obj.__A{1} + Obj.__B{1}*ones(1,m);
	Obj.__A{2} = [h(Obj.__Z{2},Obj.eta)];
	for l = [2:(Obj.__NumLayers-1)]
		Obj.__Z{l+1} = [Obj.__W{l}]*[Obj.__A{l}] + Obj.__B{l} * ones(1,m);
		Obj.__A{l+1} = [h(Obj.__Z{l+1},Obj.eta)];
	endfor
	
	[dmmy,Predictions] = max(Obj.__A{end});
endfunction
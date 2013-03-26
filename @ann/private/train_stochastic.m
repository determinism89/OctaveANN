## -*- texinfo -*-
## @deftypefn {Function File} train_stochastic(@var{ANN_obj},@var{X},@var{Y},@var{GAM})
## 
## Train an ann object via stochastic gradient descent (selecting a random data set on each epoch).
## 
## @end deftypefn

function Obj = train_stochastic(Obj,X,Y,GAM)
	m = size(X,2);
	
	Obj.__Epoch = 0;
	
	do
		M = ceil(rand*m);		
		Obj.__Epoch += 1;
		if (mod((Obj.__Epoch/GAM)*10,1)==0)
			disp((Obj.__Epoch/GAM)*100)
		endif
		
		%clear variables
		Obj.__j = 0;
		Obj.__WOld = Obj.__W;
		Obj.__DeltaW1 = Obj.__DeltaW2;
		Obj.__DeltaW2 = Obj.__DeltaW0;
		Obj.__DeltaB1 = Obj.__DeltaB2;
		Obj.__DeltaB2 = Obj.__DeltaB0;
		
		%----------------------------------------------
		%			Propogate
		%----------------------------------------------
		%Initialize the input/output values
		Obj.__A{1} = X(:,M);
		
		%Forward Propogate the node values
		Obj.__Z{2} = [Obj.__W{1}]*Obj.__A{1} + Obj.__B{1};
		Obj.__A{2} = [h(Obj.__Z{2},Obj.eta)];
		for l = [2:(Obj.__NumLayers-1)]
			Obj.__Z{l+1} = [Obj.__W{l}]*[Obj.__A{l}] + Obj.__B{l};
			Obj.__A{l+1} = [h(Obj.__Z{l+1},Obj.eta)];
		endfor
		
		%Backward Propogate the errors
		Obj.__j = sum(sum(1/2*(Obj.__A{end}-[Y(:,M)]).*(Obj.__A{end}-[Y(:,M)])));
		
		Obj.__Err{end} = (Obj.__A{end} - [Y(:,M)]).*(Obj.__A{end}.*(1-Obj.__A{end}));
		for l = [(Obj.__NumLayers-1):-1:2]
			Obj.__Err{l} = [Obj.__W{l}]'*Obj.__Err{l+1}.*(Obj.__A{l}.*(1-Obj.__A{l}));
			Obj.__DeltaW2{l} = Obj.__Err{l+1}*[Obj.__A{l}]';
			Obj.__DeltaB2{l} = sum(Obj.__Err{l+1},2);
		endfor
		Obj.__DeltaW2{1} = Obj.__Err{2}*[Obj.__A{1}]';
		Obj.__DeltaB2{1} = sum(Obj.__Err{2},2);
		%----------------------------------------------
		%----------------------------------------------
		
		Obj.__Wsumsqr = 0;
		%update weights
		for l = [1:(Obj.__NumLayers-1)]
			Obj.__Wsumsqr += (1/2)*sum(sum(Obj.__W{l}.^2));
			Obj.__W{l} += -Obj.alpha * ((1/m) * (Obj.__DeltaW2{l} + .9*Obj.__DeltaW1{l}) + Obj.lambda * Obj.__W{l});
			Obj.__B{l} += -Obj.alpha * ((1/m) * (Obj.__DeltaB2{l} + .9*Obj.__DeltaB1{l}));
		endfor
		
		Obj.__J(1) = Obj.__J(2);
		Obj.__J(2) = Obj.__j + (Obj.lambda/2) * Obj.__Wsumsqr;
		
		if Obj.__J(2)<(Obj.__J(1)*1.001)
			Obj.alpha = Obj.alpha*1.05;
		else
			Obj.__W = Obj.__WOld;
			Obj.__DeltaW2 = Obj.__DeltaW0;
			Obj.alpha = Obj.alpha*.75;
		endif
		
		if length(Obj.Graphics)>500
			Obj.Graphics = [];
		endif
		
		PRESS = kbhit(1);
		if ~isempty(PRESS)
			EXECUTE = input('>>: ',"s")
			eval(EXECUTE)
		endif
	until Obj.__Epoch>GAM
endfunction
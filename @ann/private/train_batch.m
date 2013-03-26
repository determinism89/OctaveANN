## -*- texinfo -*-
## @deftypefn {Function File} train_batch(@var{ANN_obj},@var{X},@var{Y},@var{GAM})
## @deftypefnx {Function File} train_batch(@var{ANN_obj},@var{FILENAME},@var{GAM})
## 
## Train an ann object via batch gradient descent (across all data values on each epoch).
## @end deftypefn

function Obj = train_batch(Obj,varargin)
	if ischar(varargin{1,1})
		FILENAME = varargin{1,1};
		INDX = varargin{1,2};
		GAM = varargin{1,3};
		m = INDX(2)-INDX(1)+1;
		
		MAT = dlmread(FILENAME,',',[INDX(1),0,INDX(2),785]);
		X = [MAT(:,2:end)]';
		size(X)
		Yraw = MAT(:,1);
		Y = zeros(10,m);
		for ii = 1:m
			Y(Yraw(ii)+1,ii)=1;
		endfor
	else
		X = varargin{1,1};
		Y = varargin{1,2};
		m = size(X,2);
		GAM = varargin{1,3};
	endif
	H = line(Obj.Graphics(1,:),Obj.Graphics(2,:));
	epoch0 = Obj.__Epoch;
	do
		++Obj.__Epoch;
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
		Obj.__A{1} = X;
		
		%Forward Propogate the node values
		Obj.__Z{2} = [Obj.__W{1}]*Obj.__A{1} + Obj.__B{1}*ones(1,m);
		Obj.__A{2} = [h(Obj.__Z{2},Obj.eta)];
		for l = [2:(Obj.__NumLayers-1)]
			Obj.__Z{l+1} = [Obj.__W{l}]*[Obj.__A{l}] + Obj.__B{l} * ones(1,m);
			Obj.__A{l+1} = [h(Obj.__Z{l+1},Obj.eta)];
		endfor
		
		%Backward Propogate the errors
		Obj.__j = sum(sum(1/2*(Obj.__A{end}-Y).*(Obj.__A{end}-Y)));
		
		Obj.__Err{end} = (Obj.__A{end} - Y).*(Obj.__A{end}.*(1-Obj.__A{end}));
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
			Obj.__W{l} += -Obj.alpha * ((1/m) * (Obj.__DeltaW2{l} + .99*Obj.__DeltaW1{l}) + Obj.lambda * Obj.__W{l});
			Obj.__B{l} += -Obj.alpha * ((1/m) * (Obj.__DeltaB2{l} + .99*Obj.__DeltaB1{l}));
		endfor
		
		Obj.__J(1) = Obj.__J(2);
		Obj.__J(2) = Obj.__j/m + (Obj.lambda/2) * Obj.__Wsumsqr;
		
		if Obj.__J(2)<(Obj.__J(1)*1.001)
			Obj.alpha = Obj.alpha*1.05;
		else
			Obj.__W = Obj.__WOld;
			Obj.__DeltaW2 = Obj.__DeltaW0;
			Obj.alpha = Obj.alpha*.75;
		endif
		
		Obj.Graphics = [Obj.Graphics,[Obj.__Epoch;Obj.__J(2)]];
		set(H,'xdata',Obj.Graphics(1,:),'ydata',Obj.Graphics(2,:));
		pause(.0001)
		
		if length(Obj.Graphics)>500
			Obj.Graphics = Obj.Graphics(:,[2:2:end]);
		endif
		
		PRESS = kbhit(1);
		if ~isempty(PRESS)
			EXECUTE = input('>>: ',"s")
			eval(EXECUTE)
		endif
		
		Obj.__Z = [];
		Obj.__A = [];
		Obj.__Z=cell(1,Obj.__NumLayers); %node values?
		Obj.__A=cell(1,Obj.__NumLayers); %f(Z)
		
	until Obj.__Epoch>(GAM+epoch0) %abs(Obj.__J(2)-Obj.__J(1))<GAM
		
endfunction
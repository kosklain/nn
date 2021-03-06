local ClassNLLCriterion, parent = torch.class(
    'nn.ClassNLLCriterion',
    'nn.Criterion'
)

function ClassNLLCriterion:__init(weights, sizeAverage)
    parent.__init(self)
    if sizeAverage ~= nil then
        self.sizeAverage = sizeAverage
    else
        self.sizeAverage = true
    end
    if weights then
        assert(weights:dim() == 1, "weights input should be 1-D Tensor")
        self.weights = weights
    end

    self.output_tensor = torch.zeros(1)
    self.total_weight_tensor = torch.ones(1)
    self.target = torch.zeros(1):long()
end




function ClassNLLCriterion:__len()
   if (self.weights) then
      return #self.weights
   else
      return 0
   end
end


function ClassNLLCriterion:updateOutput(input, target)
    if type(target) == 'number' then
        self.target[1] = target
    elseif target:type() == 'torch.CudaTensor' then
        self.target = target
    else
        self.target = target:long()
    end

    input.nn.ClassNLLCriterion_updateOutput(
        input,
        self.target,
        self.weights,
        self.sizeAverage,
        self.output_tensor,
        self.total_weight_tensor
    )
    self.output = self.output_tensor[1]
    return self.output, self.total_weight_tensor[1]
end

function ClassNLLCriterion:updateGradInput(input, target)
    if type(target) == 'number' then
        self.target[1] = target
    elseif target:type() == 'torch.CudaTensor' then
        self.target = target
    else
        self.target = target:long()
    end

    self.gradInput:resizeAs(input):zero()
    input.nn.ClassNLLCriterion_updateGradInput(
        input,
        self.target,
        self.weights,
        self.sizeAverage,
        self.total_weight_tensor,
        self.gradInput
    )
    return self.gradInput
end

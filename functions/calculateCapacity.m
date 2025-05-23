function params = calculateCapacity(params,otherParamsRS)
    params = calculateEffectiveChannel(params,otherParamsRS);
    params = computeBDPrecoding(params,otherParamsRS);
    params = calculateNoisePower(params,otherParamsRS);
    params = calculateCapacityDet(params,otherParamsRS);
end
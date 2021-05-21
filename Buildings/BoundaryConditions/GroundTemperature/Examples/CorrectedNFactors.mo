within Buildings.BoundaryConditions.GroundTemperature.Examples;
model CorrectedNFactors
  "Example model for undisturbed soil temperature with n-factors correction"
  extends UndisturbedSoilTemperature(
    TSoi(each useNFac=true, each nFacTha=1.7, each nFacFre=0.66));
end CorrectedNFactors;

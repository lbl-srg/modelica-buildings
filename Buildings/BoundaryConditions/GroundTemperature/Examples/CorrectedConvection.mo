within Buildings.BoundaryConditions.GroundTemperature.Examples;
model CorrectedConvection
  "Example model for undisturbed soil temperature with surface convection correction"
  extends UndisturbedSoilTemperature(TSoi(each useCon=true, each hSur=5));
end CorrectedConvection;

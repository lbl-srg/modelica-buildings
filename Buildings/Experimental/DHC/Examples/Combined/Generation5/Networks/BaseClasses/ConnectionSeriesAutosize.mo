within Buildings.Experimental.DHC.Examples.Combined.Generation5.Networks.BaseClasses;
model ConnectionSeriesAutosize
  "Model for connecting an agent to the DHC system"
  extends ConnectionSeriesStandard(
    tau=5*60,
    redeclare replaceable model Model_pipDis = PipeAutosize (
      roughness=7e-6,
      fac=1.5,
      final length=lDis,
      final dh=dhDis,
      final dp_length_nominal=dp_length_nominal),
    redeclare replaceable model Model_pipCon = PipeAutosize (
      roughness=2.5e-5,
      fac=2,
      final length=2*lCon,
      final dh=dhCon,
      final dp_length_nominal=dp_length_nominal));
  parameter Real dp_length_nominal(final unit="Pa/m") = 250
    "Pressure drop per pipe length at nominal flow rate";
end ConnectionSeriesAutosize;

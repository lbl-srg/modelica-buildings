within Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors.Validation;
model GFunction_LargeField_NDis
  "Compare actual vs worst-case n_dis_max for a 41x61 borefield"
  extends Modelica.Icons.Example;

  parameter Integer nXBorFie = 41;
  parameter Integer nYBorFie = 61;
  parameter Integer nBor = nXBorFie * nYBorFie;
  parameter Modelica.Units.SI.Position cooBor[nBor, 2] = {
    {5.0*mod(i - 1, nXBorFie), 5.0*floor((i - 1)/nXBorFie)} for i in 1:nBor};
  parameter Modelica.Units.SI.Height hBor = 150;
  parameter Modelica.Units.SI.Height dBor = 4;
  parameter Modelica.Units.SI.Radius rBor = 0.075;
  parameter Integer nClu = 5;

  final parameter Integer labels[nBor](each fixed=false);
  final parameter Integer cluSiz[nClu](each fixed=false);
  final parameter Integer n_dis_max(fixed=false) "Actual maximum unique distances";
  final parameter Integer n_max_old(fixed=false)  "Old bound: max(cluSiz.*cluSiz)";

initial equation
  (labels, cluSiz) =
    Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors.clusterBoreholes(
      nBor=nBor, cooBor=cooBor, hBor=hBor, dBor=dBor, rBor=rBor, nClu=nClu);

  n_dis_max =
    Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors.gFunctionCountMaxDis(
      nBor=nBor, cooBor=cooBor, nClu=nClu, labels=labels, cluSiz=cluSiz,
      rLin=0.0005*hBor, relTol=0.02);

  n_max_old = max(cluSiz.*cluSiz);

equation

  annotation(experiment(StopTime=0),
  Documentation(info="<html>
<p>Lightweight model to measure n_dis_max vs old bound max(cluSiz.*cluSiz).</p>
</html>"));
end GFunction_LargeField_NDis;

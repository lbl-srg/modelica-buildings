within Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.Validation;
model Analytic_20Years
  "Long term validation of ground temperature response model"
  extends Modelica.Icons.Example;

  parameter Buildings.Fluid.Geothermal.Borefields.Data.Borefield.Template
    borFieDat(conDat(
      borCon=Types.BoreholeConfiguration.SingleUTube,
      nBor=1,
      cooBor={{0,0}},
      mBor_flow_nominal=0.3,
      dp_nominal=5e4,
      hBor=100,
      rBor=0.05,
      dBor=4,
      rTub=0.02,
      kTub=0.5,
      eTub=0.002,
      xC=0.05),
    soiDat(
      kSoi=1,
      cSoi=1,
      dSoi=1e6),
    filDat(
      kFil=0,
      cFil=Modelica.Constants.small,
      dFil=Modelica.Constants.small,
      steadyState=true))
      "Borefield parameters"
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));

  Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.GroundTemperatureResponse groTemRes(
    tLoaAgg=3600,
    nCel=5,
    nSeg=12,
    borFieDat=borFieDat,
    forceGFunCalc=true) "Ground temperature response of borehole"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));

  Modelica.Blocks.Sources.CombiTimeTable timTabQ(
    tableOnFile=true,
    tableName="tab1",
    columns={2},
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    fileName=Modelica.Utilities.Files.loadResource(
      "modelica://Buildings/Resources/Data/Fluid/Geothermal/Borefields/HeatTransfer/Validation/Analytic_20Years.txt"))
        "Table for heat injected, using constant segments"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));

  Modelica.Blocks.Math.Add add(
    y(unit="K"), k1=-1)
    "Difference between FFT method and ground temperature response model"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={70,-10})));
  Modelica.Blocks.Sources.CombiTimeTable timTabT(
    tableOnFile=true,
    tableName="tab1",
    columns={3},
    smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
    fileName=Modelica.Utilities.Files.loadResource(
      "modelica://Buildings/Resources/Data/Fluid/Geothermal/Borefields/HeatTransfer/Validation/Analytic_20Years.txt"),
    y(each unit="K",
      each displayUnit="degC"))
      "Table for resulting wall temperature using FFT and linearly interpolated"
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));

  Modelica.Blocks.Sources.Constant const(k=273.15)
    "Cosntant ground temperature"
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  Modelica.Blocks.Math.Add TBorWal(y(unit="K")) "Borewall temperature"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={30,20})));
equation

  connect(TBorWal.u2, const.y)
    annotation (Line(points={{18,14},{-14,14},{-14,10},{-39,10}},
                                                color={0,0,127}));
  connect(groTemRes.delTBor, TBorWal.u1) annotation (Line(points={{-19,50},{-6,
          50},{-6,26},{18,26}}, color={0,0,127}));
  connect(add.u1, TBorWal.y) annotation (Line(points={{58,-4},{50,-4},{50,20},{
          41,20}}, color={0,0,127}));
  connect(add.u2, timTabT.y[1])
    annotation (Line(points={{58,-16},{0,-16},{0,-20},{-59,-20}},
                                                  color={0,0,127}));
  connect(groTemRes.QBor_flow, timTabQ.y[1])
    annotation (Line(points={{-41,50},{-59,50}}, color={0,0,127}));
  annotation (experiment(StopTime=630720000,Tolerance=1e-6),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Geothermal/Borefields/BaseClasses/HeatTransfer/Validation/Analytic_20Years.mos"
        "Simulate and plot"),
Documentation(info="<html>
<p>
This validation case applies the asymetrical synthetic load profile developed
by Pinel (2003) over a 20 year period by directly injecting the heat at the
borehole wall in the ground temperature response model. The difference between
the resulting borehole wall temperature and the same temperature precalculated
by using a fast Fourier transform is calculated with the <code>add</code>
component. The fast Fourier transform calculation was done using the same
g-function as was calculated by
<a href=\"modelica://Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors.gFunction\">
Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors.gFunction</a>.
</p>
<h4>References</h4>
<p>
Pinel, P. 2003. <i>Am&eacute;lioration, validation et implantation d&#8217;un algorithme de calcul
pour &eacute;valuer le transfert thermique dans les puits verticaux de syst&egrave;mes de pompes &agrave; chaleur g&eacute;othermiques</i>,
M.A.Sc. Thesis, &Eacute;cole Polytechnique de Montr&eacute;al.
</p>
</html>", revisions="<html>
<ul>
<li>
March 5, 2018, by Alex Laferri&egrave;re:<br/>
First implementation.
</li>
</ul>
</html>"));
end Analytic_20Years;

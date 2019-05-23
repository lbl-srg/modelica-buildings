within Buildings.Experimental.EnergyPlus.BaseClasses.Validation;
model FMUZoneAdapterZones1
  "Validation model for the class and functions that instantiate and communicate with an FMU for Model Exchange"
  extends Modelica.Icons.Example;
  parameter String idfName=Modelica.Utilities.Files.loadResource(
    "modelica://Buildings/Resources/Data/Experimental/EnergyPlus/Validation/RefBldgSmallOfficeNew2004_Chicago.idf")
    "Name of the IDF file";
  parameter String weaName = Modelica.Utilities.Files.loadResource(
    "modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.epw")
    "Name of the weather file";
  parameter Modelica.SIunits.HeatCapacity CZon = 6*6*2.7*1.2*1006 "Heat capacity of zone air";

  Buildings.Experimental.EnergyPlus.BaseClasses.FMUZoneAdapter fmuZonCor(
    final idfName=idfName,
    final weaName=weaName,
    final zoneName="Core_ZN",
    usePrecompiledFMU=true,
    final fmuName=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/src/EnergyPlus/FMUs/Zones1.fmu"),
    final nFluPor=2) "Adapter to EnergyPlus"
    annotation (Placement(transformation(extent={{20,24},{40,44}})));
  Modelica.Blocks.Sources.RealExpression X_w(y=0.01) "Zone absolute humidity"
    annotation (Placement(transformation(extent={{-88,44},{-68,64}})));
  Modelica.Blocks.Sources.RealExpression mIn_flow(y=0) "Inlet mass flow rate"
    annotation (Placement(transformation(extent={{-88,24},{-68,44}})));
  Modelica.Blocks.Math.Gain mOut_flow(k=-1) "Outlet mass flow rate"
    annotation (Placement(transformation(extent={{-48,0},{-28,20}})));
  Modelica.Blocks.Sources.RealExpression TIn[2](
    each y=293.15) "Inlet temperature"
    annotation (Placement(transformation(extent={{-88,-20},{-68,0}})));
  Modelica.Blocks.Sources.RealExpression QGaiRad_flow(
    y=0) "Radiative heat gain for the zone"
    annotation (Placement(transformation(extent={{-88,-46},{-68,-26}})));
  Modelica.Blocks.Continuous.Integrator TZonCor(
    k=1/CZon,
    initType=Modelica.Blocks.Types.Init.InitialState,
    y_start=294.15,
    y(final unit="K", displayUnit="degC")) "Zone air temperature"
    annotation (Placement(transformation(extent={{58,26},{78,46}})));
equation
  connect(X_w.y, fmuZonCor.X_w) annotation (Line(points={{-67,54},{0,54},{0,38},
          {18,38}},   color={0,0,127}));
  connect(fmuZonCor.m_flow[1], mIn_flow.y) annotation (Line(points={{18,33},{-24,
          33},{-24,34},{-67,34}},   color={0,0,127}));
  connect(mOut_flow.u, mIn_flow.y) annotation (Line(points={{-50,10},{-60,10},{
          -60,34},{-67,34}},color={0,0,127}));
  connect(mOut_flow.y, fmuZonCor.m_flow[2]) annotation (Line(points={{-27,10},{
          -10,10},{-10,35},{18,35}},
                                   color={0,0,127}));
  connect(TIn.y, fmuZonCor.TInlet) annotation (Line(points={{-67,-10},{6,-10},{
          6,30},{18,30}}, color={0,0,127}));
  connect(fmuZonCor.QGaiRad_flow, QGaiRad_flow.y) annotation (Line(points={{18,26},
          {10,26},{10,-36},{-67,-36}},   color={0,0,127}));
  connect(TZonCor.y, fmuZonCor.T)
    annotation (Line(points={{79,36},{88,36},{88,60},{8,60},{8,42},{18,42}},
                                                             color={0,0,127}));
  connect(fmuZonCor.QCon_flow, TZonCor.u)
    annotation (Line(points={{41,36},{56,36}},  color={0,0,127}));
  annotation (Documentation(info="<html>
<p>
Validation model that communicates with an FMU that emulates simple thermal zones.
All thermal zones are identical.
</p>
<p>
This test is done to validate the FMI API, using a FMU that is generated from JModelica
rather than EnergyPlus.
</p>
</html>", revisions="<html>
<ul><li>
March 19, 2018, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
 __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/EnergyPlus/BaseClasses/Validation/FMUZoneAdapterZones1.mos"
        "Simulate and plot"),
experiment(
      StopTime=3600,
      Tolerance=1e-06),
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})));
end FMUZoneAdapterZones1;

within Buildings.Experimental.EnergyPlus.BaseClasses.Validation;
model FMUZoneAdapterZones2
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
    final fmuName=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/src/EnergyPlus/FMUs/Zones3.fmu"),
    final nFluPor=2) "Adapter to EnergyPlus"
    annotation (Placement(transformation(extent={{20,24},{40,44}})));
  Modelica.Blocks.Sources.RealExpression X_w(y=0.01) "Zone absolute humidity"
    annotation (Placement(transformation(extent={{-88,44},{-68,64}})));
  Modelica.Blocks.Sources.RealExpression mIn_flow(y=0) "Inlet mass flow rate"
    annotation (Placement(transformation(extent={{-88,24},{-68,44}})));
  Modelica.Blocks.Math.Gain mOut_flow(k=-1) "Outlet mass flow rate"
    annotation (Placement(transformation(extent={{-50,0},{-30,20}})));
  Modelica.Blocks.Sources.RealExpression TIn[2](
    each y=293.15) "Inlet temperature"
    annotation (Placement(transformation(extent={{-88,-24},{-68,-4}})));
  Modelica.Blocks.Sources.RealExpression QGaiRad_flow(
    y=0) "Radiative heat gain for the zone"
    annotation (Placement(transformation(extent={{-88,-46},{-68,-26}})));
  Modelica.Blocks.Continuous.Integrator TZonCor(
    k=1/CZon,
    initType=Modelica.Blocks.Types.Init.InitialState,
    y_start=294.15,
    y(final unit="K", displayUnit="degC")) "Zone air temperature"
    annotation (Placement(transformation(extent={{58,26},{78,46}})));
  Buildings.Experimental.EnergyPlus.BaseClasses.FMUZoneAdapter fmuZonSou(
    final idfName=idfName,
    final weaName=weaName,
    final zoneName="South_ZN",
    final fmuName=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/src/EnergyPlus/FMUs/Zones3.fmu"),
    final nFluPor=2) "Adapter to EnergyPlus"
    annotation (Placement(transformation(extent={{20,-20},{40,0}})));
  Modelica.Blocks.Continuous.Integrator TZonSou(
    k=1/CZon,
    initType=Modelica.Blocks.Types.Init.InitialState,
    y_start=294.15,
    y(final unit="K", displayUnit="degC")) "Zone air temperature"
    annotation (Placement(transformation(extent={{58,-18},{78,2}})));
equation
  connect(X_w.y, fmuZonCor.X_w) annotation (Line(points={{-67,54},{-16,54},{-16,
          38},{18,38}},
                      color={0,0,127}));
  connect(fmuZonCor.m_flow[1], mIn_flow.y) annotation (Line(points={{18,33},{-2,
          33},{-2,34},{-67,34}},    color={0,0,127}));
  connect(mOut_flow.u, mIn_flow.y) annotation (Line(points={{-52,10},{-60,10},{
          -60,34},{-67,34}},color={0,0,127}));
  connect(mOut_flow.y, fmuZonCor.m_flow[2]) annotation (Line(points={{-29,10},{
          -10,10},{-10,35},{18,35}},
                                   color={0,0,127}));
  connect(TIn.y, fmuZonCor.TInlet) annotation (Line(points={{-67,-14},{0,-14},{
          0,30},{18,30}}, color={0,0,127}));
  connect(fmuZonCor.QGaiRad_flow, QGaiRad_flow.y) annotation (Line(points={{18,26},
          {-4,26},{-4,-36},{-67,-36}},   color={0,0,127}));
  connect(X_w.y, fmuZonSou.X_w) annotation (Line(points={{-67,54},{-16,54},{-16,
          -6},{18,-6}},   color={0,0,127}));
  connect(fmuZonSou.m_flow[1], mIn_flow.y) annotation (Line(points={{18,-11},{
          -20,-11},{-20,34},{-67,34}},
                                     color={0,0,127}));
  connect(mOut_flow.y, fmuZonSou.m_flow[2]) annotation (Line(points={{-29,10},{
          -10,10},{-10,-9},{18,-9}},   color={0,0,127}));
  connect(TIn.y, fmuZonSou.TInlet) annotation (Line(points={{-67,-14},{18,-14}},
                            color={0,0,127}));
  connect(fmuZonSou.QGaiRad_flow, QGaiRad_flow.y) annotation (Line(points={{18,-18},
          {-4,-18},{-4,-36},{-67,-36}},    color={0,0,127}));
  connect(TZonCor.y, fmuZonCor.T)
    annotation (Line(points={{79,36},{88,36},{88,60},{8,60},{8,42},{18,42}},
                                                             color={0,0,127}));
  connect(fmuZonCor.QCon_flow, TZonCor.u)
    annotation (Line(points={{41,36},{56,36}},  color={0,0,127}));
  connect(fmuZonSou.QCon_flow, TZonSou.u)
    annotation (Line(points={{41,-8},{56,-8}}, color={0,0,127}));
  connect(TZonSou.y, fmuZonSou.T) annotation (Line(points={{79,-8},{86,-8},{86,10},
          {10,10},{10,-2},{18,-2}},     color={0,0,127}));
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
 __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/EnergyPlus/BaseClasses/Validation/FMUZoneAdapterZones2.mos"
        "Simulate and plot"),
experiment(
      StopTime=3600,
      Tolerance=1e-06),
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})));
end FMUZoneAdapterZones2;

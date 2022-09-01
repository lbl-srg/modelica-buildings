within Buildings.Applications.DataCenters.DXCooled.Controls.Validation;
model AirsideEconomizer
  "Example that demonstrate the use of model
  Buildings.Applications.DataCenters.DXCooled.Controls.AirsideEconomizer"
  extends Modelica.Icons.Example;
  replaceable package Medium =
      Buildings.Media.Air;
  parameter Modelica.Units.SI.MassFlowRate mA_flow_nominal=0.43
    "Nominal air flowrate";
  Buildings.Applications.DataCenters.DXCooled.Controls.AirsideEconomizer con(
    minOAFra= 0,
    Ti=1) "Outdoor air damper controller"
    annotation (Placement(transformation(extent={{10,40},{30,60}})));
  Modelica.Blocks.Sources.Constant mixAirSetPoi(k=291.15)
    "Mixed air temperature setpoint"
    annotation (Placement(transformation(extent={{-60,70},{-40,90}})));
  Modelica.Blocks.Sources.CombiTimeTable cooMod(
    table=[0,  Integer(Buildings.Applications.DataCenters.Types.CoolingModes.FreeCooling);
           120,Integer(Buildings.Applications.DataCenters.Types.CoolingModes.FreeCooling);
           120,Integer(Buildings.Applications.DataCenters.Types.CoolingModes.PartialMechanical);
           240,Integer(Buildings.Applications.DataCenters.Types.CoolingModes.PartialMechanical);
           240,Integer(Buildings.Applications.DataCenters.Types.CoolingModes.FullMechanical);
           360,Integer(Buildings.Applications.DataCenters.Types.CoolingModes.FullMechanical)])
    "Cooling mode signal"
    annotation (Placement(transformation(extent={{-80,34},{-60,54}})));

  Buildings.Fluid.Sources.Boundary_pT OA(
    redeclare package Medium = Medium,
    nPorts=2,
    use_T_in=true,
    p(displayUnit="Pa") = 100000)
    "Boundary conditions for outside air"
    annotation (Placement(transformation(extent={{-50,-44},{-30,-24}})));
  Buildings.Fluid.Actuators.Dampers.MixingBox eco(
    redeclare package Medium = Medium,
    mOut_flow_nominal=mA_flow_nominal,
    mRec_flow_nominal=mA_flow_nominal,
    mExh_flow_nominal=mA_flow_nominal,
    use_inputFilter=false,
    dpDamExh_nominal=0.27,
    dpDamOut_nominal=0.27,
    dpDamRec_nominal=0.27,
    dpFixExh_nominal=20,
    dpFixOut_nominal=20,
    dpFixRec_nominal=20) "Airside economizer"
    annotation (Placement(transformation(extent={{-20,-48},{0,-28}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTemMixAir(
    redeclare package Medium = Medium,
    m_flow_nominal=mA_flow_nominal)
    "Temperature sensor for mixed air"
    annotation (Placement(transformation(extent={{10,-42},{30,-22}})));
  Buildings.Fluid.Sources.Boundary_pT roo(
    redeclare package Medium = Medium,
    nPorts=1,
    p=100000 + 30,
    T(displayUnit="degC") = 298.15) "Boundary conditions for room air"
    annotation (Placement(transformation(extent={{72,-72},{52,-52}})));
  Modelica.Blocks.Sources.CombiTimeTable outAir(table=[0,273.15 + 5; 120,273.15
         + 5; 120,273.15 + 20; 240,273.15 + 20; 240,273.15 + 30; 360,273.15 +
        30]) "Outdoor air temperature"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Buildings.Fluid.Sources.Boundary_pT supAir(
    redeclare package Medium = Medium,
    nPorts=1,
    p(displayUnit="Pa") = 100000 - 30) "Boundary conditions for supply air"
    annotation (Placement(transformation(extent={{72,-42},{52,-22}})));
  Modelica.Blocks.Math.RealToInteger reaToInt "Conversion from real to integer"
    annotation (Placement(transformation(extent={{-40,34},{-20,54}})));
equation
  connect(mixAirSetPoi.y, con.TMixAirSet) annotation (Line(points={{-39,80},{
          -20,80},{-20,56},{8,56}}, color={0,0,127}));
  connect(OA.ports[1], eco.port_Out)
    annotation (Line(points={{-30,-32},{-20,-32}},
                      color={0,127,255}));
  connect(eco.port_Exh, OA.ports[2])
    annotation (Line(points={{-20,-44},{-24,-44},{-24,-36},{-30,-36}},
                                color={0,127,255}));
  connect(eco.port_Sup,senTemMixAir. port_a)
    annotation (Line(points={{0,-32},{10,-32}},
                color={0,127,255}));
  connect(senTemMixAir.T, con.TMixAirMea) annotation (Line(points={{20,-21},{20,
          8},{-12,8},{-12,50},{8,50}}, color={0,0,127}));
  connect(con.y, eco.y) annotation (Line(points={{31,50},{40,50},{40,-12},{-10,
          -12},{-10,-26}}, color={0,0,127}));
  connect(eco.port_Ret, roo.ports[1])
    annotation (Line(points={{0,-44},{4,-44},{4,-62},{52,-62}},
                                                 color={0,127,255}));
  connect(outAir.y[1], OA.T_in)
    annotation (Line(points={{-59,-30},{-52,-30}}, color={0,0,127}));
  connect(senTemMixAir.port_b, supAir.ports[1])
    annotation (Line(points={{30,-32},{52,-32}}, color={0,127,255}));
  connect(con.cooMod, reaToInt.y)
    annotation (Line(points={{8,44},{-19,44}}, color={255,127,0}));
  connect(cooMod.y[1], reaToInt.u)
    annotation (Line(points={{-59,44},{-42,44}}, color={0,0,127}));
  annotation (
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Applications/DataCenters/DXCooled/Controls/Validation/AirsideEconomizer.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<P>
This example demonstrates how the outside air damper position changes under
different cooling mode. During the first 120s, the system is in
free cooling mode, and the damper position is controlled to maintain
the mixed air temperature at its setpoint. In the second
120s, the system is in partial mechanical cooling mode and
the outside air damper is fully open. As a result,
the mixed air temperature is equal to the
outdoor air temperature. In the last 120 seconds, the system is
in fully mechnical cooling mode, which means the outside air damper is fully closed, and
the mixed air temperature equals to the return air temperature.
</P>
</html>", revisions="<html>
<ul>
<li>
August 29, 2017 by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"),
    experiment(StopTime=360, Tolerance=1e-06));
end AirsideEconomizer;

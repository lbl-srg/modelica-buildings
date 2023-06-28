<<<<<<< HEAD:Buildings/Fluid/DXSystems/Cooling/WaterSource/Examples/VariableSpeedCooling.mo
within Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Examples;
model VariableSpeedCooling
=======
within Buildings.Fluid.DXSystems.Cooling.AirSource.Examples;
model VariableSpeed
>>>>>>> master:Buildings/Fluid/DXSystems/Cooling/AirSource/Examples/VariableSpeed.mo
  "Test model for variable speed DX coil"
  extends Modelica.Icons.Example;

  package Medium = Buildings.Media.Air
    "Medium model";

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=datCoi.sta[datCoi.nSta].nomVal.m_flow_nominal
    "Nominal mass flow rate";

  parameter Modelica.Units.SI.PressureDifference dp_nominal=1000
    "Pressure drop at m_flow_nominal";

  parameter
<<<<<<< HEAD:Buildings/Fluid/DXSystems/Cooling/WaterSource/Examples/VariableSpeedCooling.mo
    Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.CoolingCoil
    datCoi(
      nSta=4,
      sta={Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.BaseClasses.Stage(
        spe=900/60,
        nomVal=
        Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.BaseClasses.NominalValues(
=======
    Buildings.Fluid.DXSystems.Cooling.AirSource.Data.Generic.DXCoil
    datCoi(
      nSta=4,
      sta={Buildings.Fluid.DXSystems.Cooling.AirSource.Data.Generic.BaseClasses.Stage(
        spe=900/60,
        nomVal=
        Buildings.Fluid.DXSystems.Cooling.AirSource.Data.Generic.BaseClasses.NominalValues(
>>>>>>> master:Buildings/Fluid/DXSystems/Cooling/AirSource/Examples/VariableSpeed.mo
          Q_flow_nominal=-12000,
          COP_nominal=3,
          SHR_nominal=0.8,
          m_flow_nominal=0.9),
        perCur=
<<<<<<< HEAD:Buildings/Fluid/DXSystems/Cooling/WaterSource/Examples/VariableSpeedCooling.mo
        Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Examples.PerformanceCurves.DXCooling_Curve_I()),
      Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.BaseClasses.Stage(
        spe=1200/60,
        nomVal=
        Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.BaseClasses.NominalValues(
=======
        Buildings.Fluid.DXSystems.Cooling.AirSource.Examples.PerformanceCurves.Curve_I()),
      Buildings.Fluid.DXSystems.Cooling.AirSource.Data.Generic.BaseClasses.Stage(
        spe=1200/60,
        nomVal=
        Buildings.Fluid.DXSystems.Cooling.AirSource.Data.Generic.BaseClasses.NominalValues(
>>>>>>> master:Buildings/Fluid/DXSystems/Cooling/AirSource/Examples/VariableSpeed.mo
          Q_flow_nominal=-18000,
          COP_nominal=3,
          SHR_nominal=0.8,
          m_flow_nominal=1.2),
        perCur=
<<<<<<< HEAD:Buildings/Fluid/DXSystems/Cooling/WaterSource/Examples/VariableSpeedCooling.mo
        Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Examples.PerformanceCurves.DXCooling_Curve_I()),
      Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.BaseClasses.Stage(
        spe=1800/60,
        nomVal=
        Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.BaseClasses.NominalValues(
=======
        Buildings.Fluid.DXSystems.Cooling.AirSource.Examples.PerformanceCurves.Curve_I()),
      Buildings.Fluid.DXSystems.Cooling.AirSource.Data.Generic.BaseClasses.Stage(
        spe=1800/60,
        nomVal=
        Buildings.Fluid.DXSystems.Cooling.AirSource.Data.Generic.BaseClasses.NominalValues(
>>>>>>> master:Buildings/Fluid/DXSystems/Cooling/AirSource/Examples/VariableSpeed.mo
          Q_flow_nominal=-21000,
          COP_nominal=3,
          SHR_nominal=0.8,
          m_flow_nominal=1.5),
        perCur=
<<<<<<< HEAD:Buildings/Fluid/DXSystems/Cooling/WaterSource/Examples/VariableSpeedCooling.mo
        Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Examples.PerformanceCurves.DXCooling_Curve_II()),
      Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.BaseClasses.Stage(
        spe=2400/60,
        nomVal=
        Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.BaseClasses.NominalValues(
=======
        Buildings.Fluid.DXSystems.Cooling.AirSource.Examples.PerformanceCurves.Curve_II()),
      Buildings.Fluid.DXSystems.Cooling.AirSource.Data.Generic.BaseClasses.Stage(
        spe=2400/60,
        nomVal=
        Buildings.Fluid.DXSystems.Cooling.AirSource.Data.Generic.BaseClasses.NominalValues(
>>>>>>> master:Buildings/Fluid/DXSystems/Cooling/AirSource/Examples/VariableSpeed.mo
          Q_flow_nominal=-30000,
          COP_nominal=3,
          SHR_nominal=0.8,
          m_flow_nominal=1.8),
        perCur=
<<<<<<< HEAD:Buildings/Fluid/DXSystems/Cooling/WaterSource/Examples/VariableSpeedCooling.mo
        Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Examples.PerformanceCurves.DXCooling_Curve_III())})
    "Coil data"
    annotation (Placement(transformation(extent={{60,60},{80,80}})));

  Buildings.Fluid.HeatExchangers.DXCoils.AirSource.VariableSpeedCooling
=======
        Buildings.Fluid.DXSystems.Cooling.AirSource.Examples.PerformanceCurves.Curve_III())})
    "Coil data"
    annotation (Placement(transformation(extent={{60,60},{80,80}})));

  Buildings.Fluid.DXSystems.Cooling.AirSource.VariableSpeed
>>>>>>> master:Buildings/Fluid/DXSystems/Cooling/AirSource/Examples/VariableSpeed.mo
    varSpeDX(
    redeclare package Medium = Medium,
    final dp_nominal=dp_nominal,
    final datCoi=datCoi,
    final minSpeRat=datCoi.minSpeRat,
    final T_start=datCoi.sta[1].nomVal.TEvaIn_nominal,
    final from_dp=true,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Variable speed DX coil"
    annotation (Placement(transformation(extent={{-10,2},{10,22}})));

  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    final nPorts=1,
    final p = 101325,
    final T=293.15)
    "Sink"
    annotation (Placement(transformation(extent={{40,-20},{20,0}})));

  Buildings.Fluid.Sources.Boundary_pT sou(
    redeclare package Medium = Medium,
    final nPorts=1,
    final p = 101325 + dp_nominal,
    final use_T_in=true,
    final use_p_in=true,
    final T=299.85)
    "Source"
    annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));

  Modelica.Blocks.Sources.Ramp TEvaIn(
    final duration=600,
    final startTime=900,
    final height=5,
    final offset=273.15 + 20)
    "Evaporator coil inlet air temperature"
    annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));

  Modelica.Blocks.Sources.TimeTable speRat(
    final table=[0.0,0.0;
                 100,0.0;
                 900,0.2;
                 1800,0.8;
                 2700,0.75;
                 3600,0.75])
    "Speed ratio "
    annotation (Placement(transformation(extent={{-84,50},{-64,70}})));

  Modelica.Blocks.Sources.Ramp p(
    final duration=600,
    final height=dp_nominal,
    final offset=101325,
    final startTime=100)
    "Pressure of inlet air"
    annotation (Placement(transformation(extent={{-100,-8},{-80,12}})));

  Modelica.Blocks.Sources.Constant TConIn(
    final k=273.15 + 25)
    "Condenser inlet temperature"
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));

equation
  connect(sou.ports[1], varSpeDX.port_a)
                                        annotation (Line(
      points={{-20,-10},{-16,-10},{-16,12},{-10,12}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(varSpeDX.port_b, sin.ports[1])
                                        annotation (Line(
      points={{10,12},{14,12},{14,-10},{20,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TEvaIn.y, sou.T_in) annotation (Line(
      points={{-79,-30},{-52,-30},{-52,-6},{-42,-6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(speRat.y, varSpeDX.speRat)   annotation (Line(
      points={{-63,60},{-22,60},{-22,20},{-11,20}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(p.y, sou.p_in) annotation (Line(
      points={{-79,2},{-61.5,2},{-61.5,-2},{-42,-2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(varSpeDX.TOut, TConIn.y) annotation (Line(
      points={{-11,15},{-40.5,15},{-40.5,30},{-79,30}},
      color={0,0,127},
      smooth=Smooth.None));
<<<<<<< HEAD:Buildings/Fluid/DXSystems/Cooling/WaterSource/Examples/VariableSpeedCooling.mo
  annotation (             __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/DXCoils/AirSource/Examples/VariableSpeedCooling.mos"
=======
  annotation (             __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/DXSystems/Cooling/AirSource/Examples/VariableSpeed.mos"
>>>>>>> master:Buildings/Fluid/DXSystems/Cooling/AirSource/Examples/VariableSpeed.mo
        "Simulate and plot"),
    experiment(Tolerance=1e-6, StopTime=3600),
            Documentation(info="<html>
<p>
This is a test model for
<a href=\"modelica://Buildings.Fluid.DXSystems.Cooling.AirSource.VariableSpeed\">
Buildings.Fluid.DXSystems.Cooling.AirSource.VariableSpeed</a>.
The model has open-loop control and time-varying input conditions.
</p>
</html>",
revisions="<html>
<ul>
<li>
March 19, 2023 by Xing Lu and Karthik Devaprasad:<br/>
Updated model name and instance class for <code>varSpeDX</code>.<br/>
Updated conneection statements due to input instance change on <code>varSpeDX</code>
from <code>TConIn</code> to <code>TOut</code>.<br/>
Updated formatting for readability.
</li>
<li>
January 22, 2016, by Michael Wetter:<br/>
Corrected type declaration of pressure difference.
This is
for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/404\">#404</a>.
</li>
<li>
December 22, 2014 by Michael Wetter:<br/>
Removed <code>Modelica.Fluid.System</code>
to address issue
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/311\">#311</a>.
</li>
<li>
July 26, 2012 by Kaustubh Phalak:<br/>
First implementation.
</li>
</ul>
</html>"));
end VariableSpeedCooling;

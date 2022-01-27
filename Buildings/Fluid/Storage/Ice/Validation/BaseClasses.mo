within Buildings.Fluid.Storage.Ice.Validation;
package BaseClasses "Base classes for validation package"

  partial model PartialExample "Base example"
    extends Modelica.Icons.Example;
    package Medium = Buildings.Media.Antifreeze.PropyleneGlycolWater (
      property_T=293.15,
      X_a=0.30);
    parameter String fileName "Calibration data file";

    parameter Modelica.Units.SI.Mass mIce_max=2846.35
      "Nominal mass of ice in the tank";
    parameter Modelica.Units.SI.Mass mIce_start=0.90996030*mIce_max
      "Start value of ice mass in the tank";
    parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=1
      "Nominal mass flow rate";
    parameter Modelica.Units.SI.PressureDifference dp_nominal=100000
      "Pressure difference";
    parameter Buildings.Fluid.Storage.Ice.Data.Tank.Experiment per "Ice tank performance curves"
      annotation (Placement(transformation(extent={{60,60},{80,80}})));

    Buildings.Fluid.Storage.Ice.ControlledTank iceTan(
      redeclare package Medium = Medium,
      m_flow_nominal=m_flow_nominal,
      dp_nominal=dp_nominal,
      mIce_max=mIce_max,
      mIce_start=mIce_start,
      per=per) "Ice tank"
      annotation (Placement(transformation(extent={{10,-10},{30,10}})));
    Buildings.Fluid.Sources.MassFlowSource_T sou(
      redeclare package Medium = Medium,
      use_m_flow_in=true,
      use_T_in=true,
      nPorts=1) "Mass flow source"
      annotation (Placement(transformation(extent={{-36,-10},{-16,10}})));
    Buildings.Fluid.Sources.Boundary_pT bou(
      redeclare package Medium = Medium,
      nPorts=1)
      "Pressure source"
      annotation (Placement(transformation(extent={{90,-10},{70,10}})));
    Buildings.Fluid.FixedResistances.PressureDrop res(
      redeclare package Medium = Medium,
      m_flow_nominal=m_flow_nominal,
      dp_nominal=500)
      "Flow resistance"
      annotation (Placement(transformation(extent={{38,-10},{58,10}})));
    Modelica.Blocks.Sources.IntegerConstant mod
      "Mode of operation"
      annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
    Modelica.Blocks.Sources.CombiTimeTable dat(
      tableOnFile=true,
      tableName="tab",
      columns=2:5,
      fileName=fileName)
      "Flowrate measurements"
      annotation (Placement(transformation(extent={{-80,60},{-60,80}})));

    Modelica.Thermal.HeatTransfer.Celsius.ToKelvin TIn
      "Conversion from Celsius to Kelvin"
      annotation (Placement(transformation(extent={{-74,24},{-54,44}})));
    Modelica.Thermal.HeatTransfer.Celsius.ToKelvin TOut
      "Outlet temperature in Kelvin"
      annotation (Placement(transformation(extent={{-62,-30},{-42,-10}})));

    Modelica.Blocks.Math.Add TSet "Temperature setpoint"
      annotation (Placement(transformation(extent={{-30,-60},{-10,-40}})));
    Modelica.Blocks.Sources.Constant offSet(k=0) "An offset for setpoint control"
      annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));

  equation
    connect(sou.ports[1], iceTan.port_a)
      annotation (Line(points={{-16,0},{10,0}},  color={0,127,255}));
    connect(iceTan.port_b, res.port_a)
      annotation (Line(points={{30,0},{38,0}}, color={0,127,255}));
    connect(res.port_b, bou.ports[1])
      annotation (Line(points={{58,0},{70,0}}, color={0,127,255}));
    connect(mod.y, iceTan.u) annotation (Line(points={{-19,70},{-2,70},{-2,8},{
            8,8}},
                 color={255,127,0}));
    connect(dat.y[3], sou.m_flow_in) annotation (Line(points={{-59,70},{-46,70},
            {-46,8},{-38,8}},
                         color={0,0,127}));
    connect(dat.y[1], TIn.Celsius) annotation (Line(points={{-59,70},{-52,70},{
            -52,48},{-80,48},{-80,34},{-76,34}},
                                             color={0,0,127}));
    connect(TIn.Kelvin, sou.T_in) annotation (Line(points={{-53,34},{-48,34},{
            -48,4},{-38,4}},
                         color={0,0,127}));
    connect(dat.y[2], TOut.Celsius) annotation (Line(points={{-59,70},{-52,70},
            {-52,48},{-80,48},{-80,-20},{-64,-20}},
                                               color={0,0,127}));
    connect(TOut.Kelvin, TSet.u1) annotation (Line(points={{-41,-20},{-36,-20},
            {-36,-44},{-32,-44}},
                             color={0,0,127}));
    connect(offSet.y, TSet.u2) annotation (Line(points={{-59,-50},{-42,-50},{
            -42,-56},{-32,-56}},
                        color={0,0,127}));
    connect(TSet.y, iceTan.TOutSet) annotation (Line(points={{-9,-50},{-2,-50},
            {-2,3},{8,3}},   color={0,0,127}));
    annotation (
      Documentation(info="<html>
</html>",   revisions="<html>
<ul>
<li>
December 14, 2021, by Yangyang Fu:<br/>
First implementation.
</li>
</ul>

</html>"));
  end PartialExample;
end BaseClasses;

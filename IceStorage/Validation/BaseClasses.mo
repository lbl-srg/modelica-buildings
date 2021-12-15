within IceStorage.Validation;
package BaseClasses "Baseclasses"

  partial model PartialExample "Base example"
    extends Modelica.Icons.Example;
    package Medium = Buildings.Media.Antifreeze.PropyleneGlycolWater (
      property_T=293.15,
      X_a=0.30);
    parameter String fileName "Calibration data file";
    parameter Real coeCha[6] = {1.99810397E-04,0,0,0,0,0} "Coefficient for charging curve";
    parameter Real coeDisCha[6] = {5.54E-05,-1.45679E-04,9.28E-05,1.126122E-03,
        -1.1012E-03,3.00544E-04} "Coefficient for discharging curve";
    parameter Real dt = 10 "Time step used in the samples for curve fitting";

    parameter Modelica.SIunits.Mass mIce_max=2846.35
      "Nominal mass of ice in the tank";
    parameter Modelica.SIunits.Mass mIce_start=0.90996030*mIce_max
      "Start value of ice mass in the tank";

    parameter Modelica.SIunits.MassFlowRate m_flow_nominal=1
      "Nominal mass flow rate";
    parameter Modelica.SIunits.PressureDifference dp_nominal=100000
      "Pressure difference";


    IceStorage.IceTank iceTan(
      redeclare package Medium = Medium,
      m_flow_nominal=m_flow_nominal,
      dp_nominal=dp_nominal,
      mIce_max=mIce_max,
      mIce_start=mIce_start,
      coeCha=coeCha,
      dtCha=dt,
      coeDisCha=coeDisCha,
      dtDisCha=dt)
      annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
    Buildings.Fluid.Sources.MassFlowSource_T sou(
      redeclare package Medium = Medium,
      use_m_flow_in=true,
      use_T_in=true,
      nPorts=1)
      annotation (Placement(transformation(extent={{-54,-10},{-34,10}})));
    Buildings.Fluid.Sources.Boundary_pT bou(
      redeclare package Medium = Medium,
      nPorts=1)
      annotation (Placement(transformation(extent={{86,-10},{66,10}})));
    Buildings.Fluid.FixedResistances.PressureDrop res(
      redeclare package Medium = Medium,
      m_flow_nominal=m_flow_nominal,
      dp_nominal=500)
      annotation (Placement(transformation(extent={{26,-10},{46,10}})));
    Modelica.Blocks.Sources.IntegerConstant mod
      "Mode"
      annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
    Modelica.Blocks.Sources.CombiTimeTable dat(
      tableOnFile=true,
      tableName="tab",
      columns=2:5,
      fileName=fileName)
      "Flowrate measurements"
      annotation (Placement(transformation(extent={{-100,60},{-80,80}})));

    Modelica.Thermal.HeatTransfer.Celsius.ToKelvin TIn
      "Inlet temperature in Kelvin"
      annotation (Placement(transformation(extent={{-92,24},{-72,44}})));
    Modelica.Thermal.HeatTransfer.Celsius.ToKelvin TOut
      "Outlet temperature in Kelvin"
      annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));

  equation
    connect(sou.ports[1], iceTan.port_a)
      annotation (Line(points={{-34,0},{-10,0}}, color={0,127,255}));
    connect(iceTan.port_b, res.port_a)
      annotation (Line(points={{10,0},{26,0}}, color={0,127,255}));
    connect(res.port_b, bou.ports[1])
      annotation (Line(points={{46,0},{66,0}}, color={0,127,255}));
    connect(mod.y, iceTan.u) annotation (Line(points={{-39,70},{-20,70},{-20,8},{-12,
            8}}, color={255,127,0}));
    connect(dat.y[3], sou.m_flow_in) annotation (Line(points={{-79,70},{-64,70},{-64,
            8},{-56,8}}, color={0,0,127}));
    connect(dat.y[1], TIn.Celsius) annotation (Line(points={{-79,70},{-70,70},{-70,
            48},{-98,48},{-98,34},{-94,34}}, color={0,0,127}));
    connect(TIn.Kelvin, sou.T_in) annotation (Line(points={{-71,34},{-66,34},{-66,
            4},{-56,4}}, color={0,0,127}));
    connect(dat.y[2], TOut.Celsius) annotation (Line(points={{-79,70},{-70,70},{-70,
            48},{-98,48},{-98,-40},{-82,-40}}, color={0,0,127}));
    connect(TOut.Kelvin, iceTan.TOutSet) annotation (Line(points={{-59,-40},{-20,-40},
            {-20,3},{-12,3}}, color={0,0,127}));
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

within Buildings.Fluid.HeatExchangers.HeatPumps.BaseClasses;
partial block PartialCapacity
  "Partial block for capacity calculation at given temperature and flow fraction"
  extends Modelica.Blocks.Interfaces.BlockIcon;
  parameter Integer nSta "Number of coil stages (not counting the off stage)"
  annotation(Evaluate=true);

  Modelica.Blocks.Interfaces.IntegerInput mode(final min=0, final max=2)
    "Mode 0:off, 1:heating, 2:cooling"
    annotation (Placement(transformation(extent={{-124,88},{-100,112}}),
        iconTransformation(extent={{-120,90},{-100,110}})));
  Modelica.Blocks.Interfaces.RealInput T2In(
    quantity="Temperature",
    unit="K",
    displayUnit="degC") "Temperature of water entering the heat pump"
     annotation (Placement(transformation(extent={{-120,-30},{-100,-10}})));
  Modelica.Blocks.Interfaces.RealInput m2_flow(
    quantity="MassFlowRate",
    unit="kg/s") "Water mass flow rate"
    annotation (Placement(transformation(extent={{-120,-70},{-100,-50}})));
  Modelica.Blocks.Interfaces.RealInput m1_flow(
    quantity="MassFlowRate",
    unit="kg/s") "Air mass flow rate"
    annotation (Placement(transformation(extent={{-120,10},{-100,30}})));
  Modelica.Blocks.Interfaces.RealInput T1In(
    quantity="Temperature",
    unit="K",
    displayUnit="degC") "Temperature of air entering the heat pump"
    annotation (Placement(transformation(extent={{-120,50},{-100,70}})));

  parameter Modelica.SIunits.MassFlowRate m1_flow_small
    "Small air mass flow rate for regularization";
  parameter Modelica.SIunits.MassFlowRate m2_flow_small
    "Small water mass flow rate for regularization";

  output Real[nSta] ff1(each min=0)
    "Air flow fraction: ratio of actual air flow rate by rated mass flwo rate";
//  output Real[nSta] ff2(each min=0)
//    "Water flow fraction: ratio of actual water flow rate by rated mass flwo rate";
  Modelica.Blocks.Interfaces.RealOutput Q_flow[nSta](
    each max=0,
    each unit="W") "Total cooling capacity"
    annotation (Placement(transformation(extent={{100,-50},{120,-30}})));
  Modelica.Blocks.Interfaces.RealOutput EIR[nSta](each min=0)
    "Energy Input Ratio"
    annotation (Placement(transformation(extent={{100,30},{120,50}})));

//  Modelica.Blocks.Interfaces.RealOutput QRecWas_flow[nSta](each min=0)
//    "Recoverable waste heat, positive value "
//     annotation (Placement(transformation(extent={{100,-10},{120,10}})));

//------------------------------Capacity calculation---------------------------------//
  output Real cap_T[nSta](each min=0, each nominal=1, each start=1)
    "Capacity modification factor as a function of temperature";
  output Real cap_FF1[nSta](each min=0, each nominal=1, each start=1)
    "Capacity modification factor as a function of air flow fraction";
//  output Real cap_FF2[nSta](each min=0, each nominal=1, each start=1)
//    "Capacity modification factor as a function of water flow fraction";
//----------------------------Energy Input Ratio---------------------------------//
  output Real EIR_T[nSta](each min=0, each nominal=1, each start=1)
    "EIR modification factor as a function of temperature";
  output Real EIR_FF1[nSta](each min=0, each nominal=1, each start=1)
    "EIR modification factor as a function of air flow fraction";
//  output Real EIR_FF2[nSta](each min=0, each nominal=1, each start=1)
//    "EIR modification factor as a function of water flow fraction";

//  output Real wasHea_T[nSta](each min=0, each nominal=1, each start=1)
//    "Recoverable heat modification factor as a function of temperature";

  output Real corFac1[nSta](each min=0, each max=1, each nominal=1, each start=1)
    "Correction factor that is one inside the valid air flow fraction, and attains zero below the valid flow fraction";
//  output Real corFac2[nSta](each min=0, each max=1, each nominal=1, each start=1)
//    "Correction factor that is one inside the valid water flow fraction, and attains zero below the valid flow fraction";

   annotation (
    defaultComponentName="cooCap",
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,100}}),
                    graphics={
        Text(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,255},
          textStyle={TextStyle.Italic},
          textString="f(T,m)")}),
          Documentation(info="<html>
<p>
This partial block is the base class for
<a href=\"modelica://Buildings.Fluid.HeatExchangers.HeatPumps.WaterToAir.BaseClasses.CoolingCapacity\"> 
Buildings.Fluid.HeatExchangers.HeatPumps.WaterToAir.BaseClasses.CoolingCapacity</a> and
<a href=\"modelica://Buildings.Fluid.HeatExchangers.HeatPumps.WaterToAir.BaseClasses.HeatingCapacity\"> 
Buildings.Fluid.HeatExchangers.HeatPumps.WaterToAir.BaseClasses.HeatingCapacity</a>. 
See documentation of above mentioned blocks for detailed equations used in calculation of 
the heating and cooling capacities.
</p>
</html>",
revisions="<html>
<ul>
<li>
February 15, 2013 by Kaustubh Phalak:<br>
First implementation. 
</li>
</ul>

</html>"),
    Diagram(graphics));
end PartialCapacity;

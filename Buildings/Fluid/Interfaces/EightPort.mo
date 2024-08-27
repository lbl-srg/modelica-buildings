within Buildings.Fluid.Interfaces;
partial model EightPort "Partial model with eight ports"

  replaceable package Medium1 =
    Modelica.Media.Interfaces.PartialMedium "Medium 1 in the component"
      annotation (choices(
        choice(redeclare package Medium1 = Buildings.Media.Air "Moist air"),
        choice(redeclare package Medium1 = Buildings.Media.Water "Water"),
        choice(redeclare package Medium1 =
            Buildings.Media.Antifreeze.PropyleneGlycolWater (
          property_T=293.15,
          X_a=0.40)
          "Propylene glycol water, 40% mass fraction")));
  replaceable package Medium2 =
    Modelica.Media.Interfaces.PartialMedium "Medium 2 in the component"
      annotation (choices(
        choice(redeclare package Medium2 = Buildings.Media.Air "Moist air"),
        choice(redeclare package Medium2 = Buildings.Media.Water "Water"),
        choice(redeclare package Medium2 =
            Buildings.Media.Antifreeze.PropyleneGlycolWater (
          property_T=293.15,
          X_a=0.40)
          "Propylene glycol water, 40% mass fraction")));
  replaceable package Medium3 =
    Modelica.Media.Interfaces.PartialMedium "Medium 3 in the component"
      annotation (choices(
        choice(redeclare package Medium3 = Buildings.Media.Air "Moist air"),
        choice(redeclare package Medium3 = Buildings.Media.Water "Water"),
        choice(redeclare package Medium3 =
            Buildings.Media.Antifreeze.PropyleneGlycolWater (
          property_T=293.15,
          X_a=0.40)
          "Propylene glycol water, 40% mass fraction")));
  replaceable package Medium4 =
    Modelica.Media.Interfaces.PartialMedium "Medium 4 in the component"
      annotation (choices(
        choice(redeclare package Medium4 = Buildings.Media.Air "Moist air"),
        choice(redeclare package Medium4 = Buildings.Media.Water "Water"),
        choice(redeclare package Medium4 =
            Buildings.Media.Antifreeze.PropyleneGlycolWater (
          property_T=293.15,
          X_a=0.40)
          "Propylene glycol water, 40% mass fraction")));

  parameter Boolean allowFlowReversal1 = true
    "= true to allow flow reversal in medium 1, false restricts to design direction (port_a -> port_b)"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);
  parameter Boolean allowFlowReversal2 = true
    "= true to allow flow reversal in medium 2, false restricts to design direction (port_a -> port_b)"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);
  parameter Boolean allowFlowReversal3 = true
    "= true to allow flow reversal in medium 3, false restricts to design direction (port_a -> port_b)"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);
  parameter Boolean allowFlowReversal4 = true
    "= true to allow flow reversal in medium 4, false restricts to design direction (port_a -> port_b)"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);

  parameter Modelica.Units.SI.SpecificEnthalpy h_outflow_a1_start=Medium1.h_default
    "Start value for enthalpy flowing out of port a1"
    annotation (Dialog(tab="Advanced", group="Initialization"));

  parameter Modelica.Units.SI.SpecificEnthalpy h_outflow_b1_start=Medium1.h_default
    "Start value for enthalpy flowing out of port b1"
    annotation (Dialog(tab="Advanced", group="Initialization"));

  parameter Modelica.Units.SI.SpecificEnthalpy h_outflow_a2_start=Medium2.h_default
    "Start value for enthalpy flowing out of port a2"
    annotation (Dialog(tab="Advanced", group="Initialization"));

  parameter Modelica.Units.SI.SpecificEnthalpy h_outflow_b2_start=Medium2.h_default
    "Start value for enthalpy flowing out of port b2"
    annotation (Dialog(tab="Advanced", group="Initialization"));

  parameter Modelica.Units.SI.SpecificEnthalpy h_outflow_a3_start=Medium3.h_default
    "Start value for enthalpy flowing out of port a1"
    annotation (Dialog(tab="Advanced", group="Initialization"));

  parameter Modelica.Units.SI.SpecificEnthalpy h_outflow_b3_start=Medium3.h_default
    "Start value for enthalpy flowing out of port b1"
    annotation (Dialog(tab="Advanced", group="Initialization"));

  parameter Modelica.Units.SI.SpecificEnthalpy h_outflow_a4_start=Medium4.h_default
    "Start value for enthalpy flowing out of port a1"
    annotation (Dialog(tab="Advanced", group="Initialization"));

  parameter Modelica.Units.SI.SpecificEnthalpy h_outflow_b4_start=Medium4.h_default
    "Start value for enthalpy flowing out of port b1"
    annotation (Dialog(tab="Advanced", group="Initialization"));

  Modelica.Fluid.Interfaces.FluidPort_a port_a1(
                     redeclare final package Medium = Medium1,
                     m_flow(min=if allowFlowReversal1 then -Modelica.Constants.inf else 0),
                     h_outflow(start=h_outflow_a1_start))
    "Fluid connector a1 (positive design flow direction is from port_a1 to port_b1)"
    annotation (Placement(transformation(extent={{-110,70},{-90,90}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b1(
                     redeclare final package Medium = Medium1,
                     m_flow(max=if allowFlowReversal1 then +Modelica.Constants.inf else 0),
                     h_outflow(start=h_outflow_b1_start))
    "Fluid connector b1 (positive design flow direction is from port_a1 to port_b1)"
    annotation (Placement(transformation(extent={{110,70},{90,90}}), iconTransformation(extent={{110,70},
            {90,90}})));

  Modelica.Fluid.Interfaces.FluidPort_a port_a2(
                     redeclare final package Medium = Medium2,
                     m_flow(min=if allowFlowReversal2 then -Modelica.Constants.inf else 0),
                     h_outflow(start=h_outflow_a2_start))
    "Fluid connector a2 (positive design flow direction is from port_a2 to port_b2)"
    annotation (Placement(transformation(extent={{90,20},{110,40}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b2(
                     redeclare final package Medium = Medium2,
                     m_flow(max=if allowFlowReversal2 then +Modelica.Constants.inf else 0),
                     h_outflow(start=h_outflow_b2_start))
    "Fluid connector b2 (positive design flow direction is from port_a2 to port_b2)"
    annotation (Placement(transformation(extent={{-90,20},{-110,40}}),
                iconTransformation(extent={{-90,20},{-110,40}})));

  Modelica.Fluid.Interfaces.FluidPort_a port_a3(
                     redeclare final package Medium = Medium3,
                     m_flow(min=if allowFlowReversal3 then -Modelica.Constants.inf else 0),
                     h_outflow(start=h_outflow_a3_start))
    "Fluid connector a1 (positive design flow direction is from port_a3 to port_b3)"
    annotation (Placement(transformation(extent={{-110,-42},{-90,-22}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b3(
                     redeclare final package Medium = Medium3,
                     m_flow(max=if allowFlowReversal3 then +Modelica.Constants.inf else 0),
                     h_outflow(start=h_outflow_b3_start))
    "Fluid connector b2 (positive design flow direction is from port_a3 to port_b3)"
    annotation (Placement(transformation(extent={{110,-40},{90,-20}}),
                iconTransformation(extent={{110,-41},{90,-21}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a4(
                     redeclare final package Medium = Medium4,
                     m_flow(min=if allowFlowReversal4 then -Modelica.Constants.inf else 0),
                     h_outflow(start=h_outflow_a4_start))
    "Fluid connector a1 (positive design flow direction is from port_a4 to port_b4)"
    annotation (Placement(transformation(extent={{90,-90},{110,-70}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b4(
                     redeclare final package Medium = Medium4,
                     m_flow(max=if allowFlowReversal4 then +Modelica.Constants.inf else 0),
                     h_outflow(start=h_outflow_b4_start))
    "Fluid connector b2 (positive design flow direction is from port_a4 to port_b4)"
    annotation (Placement(transformation(extent={{-90,-90},{-110,-70}}),
                iconTransformation(extent={{-90,-95},{-110,-75}})));
  annotation (
    preferredView="info",
    Documentation(info="<html>
<p>This model defines an interface for components with eight ports. The parameters <code>allowFlowReversal1,
</code> <code>allowFlowReversal2</code>, <code>allowFlowReversal3</code> and <code>allowFlowReversal4</code> 
may be used by models that extend this model to treat flow reversal. </p>
<p>This model is identical to <a href=\"modelica://Modelica.Fluid.Interfaces.PartialTwoPort\">Modelica.Fluid.Interfaces.PartialTwoPort</a>, except that it has eight ports. </p>
</html>", revisions="<html>
<ul>
<li>
August 27, 2024, by Jianjun Hu:<br/>
Corrected dropdown media choice.
See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1924\">#1924</a>.
</li>
<li>
January 18, 2019, by Jianjun Hu:<br/>
Limited the media choice.
See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1050\">#1050</a>.
</li>
<li>July 2014, by Damien Picard:<br/>First implementation. </li>
</ul>
</html>"),
    Icon(coordinateSystem(
          preserveAspectRatio=false,
          extent={{-100,-100},{100,100}},
          grid={1,1}), graphics={Text(
          extent={{-151,147},{149,107}},
          textColor={0,0,255},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255},
          textString="%name")}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}),
                    graphics));
end EightPort;

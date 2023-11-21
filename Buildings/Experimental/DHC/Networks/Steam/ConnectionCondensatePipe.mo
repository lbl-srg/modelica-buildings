within Buildings.Experimental.DHC.Networks.Steam;
model ConnectionCondensatePipe
  "Connection for a steam district heating network featuring the condensate return pipe"
  extends
    Buildings.Experimental.DHC.Networks.BaseClasses.PartialConnection2Pipe2Medium(
    redeclare final model Model_pipDisRet =
        Buildings.Fluid.FixedResistances.PressureDrop (
          final dp_nominal=dp_nominal),
    redeclare model Model_pipDisSup =
        Buildings.Fluid.FixedResistances.LosslessPipe);
  parameter Modelica.Units.SI.PressureDifference dp_nominal(displayUnit="Pa")
    "Pressure drop at nominal mass flow rate"
    annotation (Dialog(group="Nominal condition"));
  Buildings.Fluid.FixedResistances.PressureDrop pipConRet(
    redeclare package Medium = MediumRet,
    m_flow_nominal=mCon_flow_nominal,
    final dp_nominal=dp_nominal)
    "Connection return pipe"
    annotation (Placement(transformation(
      extent={{10,-10},{-10,10}},rotation=90,origin={20,-10})));
equation
  connect(port_aCon, pipConRet.port_a)
    annotation (Line(points={{20,120},{20,0}}, color={0,127,255}));
  connect(pipConRet.port_b, junConRet.port_3)
    annotation (Line(points={{20,-20},{20,-70}}, color={0,127,255}));
  connect(port_bCon, junConSup.port_3)
    annotation (Line(points={{-20,120},{-20,-30}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{48,76},{72,24}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-76,-48},{-20,-72}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0})}),
        Diagram(
          coordinateSystem(preserveAspectRatio=false)),
          defaultComponentName="con",
    Documentation(info="<html>
<p>
This network connection model contains one pipe declaration 
for the condensate pipe, featuring a fixed hydraulic resistance. 
This model is intended for steam heating systems that utilize 
a split-medium approach with two separate medium declarations 
between liquid and vapor states. 
</p>
<p>
In this model, it is assumed that there are no mass losses in 
the network connection. Further, heat transfer with the external 
environment and transport delays are also not included.
</p>
<h4>Reference</h4>
<p>
Hinkelman, Kathryn, Saranya Anbarasu, Michael Wetter, 
Antoine Gautier, and Wangda Zuo. 2022. “A Fast and Accurate Modeling 
Approach for Water and Steam Thermodynamics with Practical 
Applications in District Heating System Simulation.” Preprint. February 24. 
<a href=\"http://dx.doi.org/10.13140/RG.2.2.20710.29762\">doi:10.13140/RG.2.2.20710.29762</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
March 2, 2022, by Kathryn Hinkelman:<br/>
First implementation.
</li>
</ul>
</html>"));
end ConnectionCondensatePipe;

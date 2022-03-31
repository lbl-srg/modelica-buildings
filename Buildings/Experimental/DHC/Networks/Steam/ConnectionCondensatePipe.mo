within Buildings.Experimental.DHC.Networks.Steam;
model ConnectionCondensatePipe
  "Connection for a steam district heating network featuring the condensate return pipe"
  extends Buildings.Experimental.DHC.Networks.BaseClasses.PartialConnection2Pipe2Medium(
    redeclare model Model_pipConRet =
        Buildings.Fluid.FixedResistances.PressureDrop (
          final dp_nominal=dp_nominal),
    redeclare final model Model_pipDisRet =
        Buildings.Fluid.FixedResistances.PressureDrop (
          final dp_nominal=dp_nominal),
    redeclare model Model_pipDisSup =
        Buildings.Fluid.FixedResistances.LosslessPipe,
    redeclare final model Model_pipConSup =
        Buildings.Fluid.FixedResistances.LosslessPipe);
  parameter Modelica.Units.SI.PressureDifference dp_nominal(displayUnit="Pa")
    "Pressure drop at nominal mass flow rate"
    annotation (Dialog(group="Nominal condition"));
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

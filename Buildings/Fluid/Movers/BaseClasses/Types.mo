within Buildings.Fluid.Movers.BaseClasses;
package Types "Package with type definitions"
  extends Modelica.Icons.TypesPackage;

  type PrescribedVariable = enumeration(
      Speed "Speed is prescribed",
      FlowRate "Flow rate is prescribed",
      PressureDifference "Pressure difference is prescribed")
    "Enumeration to choose what variable is prescribed";
  type HydraulicEfficiencyMethod = enumeration(
      NotProvided
        "Not provided, computed from other efficiency terms",
      Efficiency_VolumeFlowRate "Array of efficiency vs. volumetric flow rate",
      Power_VolumeFlowRate
        "Array of power vs. volumetric flow rate",
      EulerNumber
        "One peak point to be used for the Euler number")
    "Enumeration to choose the computation method for total efficiency and hydraulic efficiency"
    annotation (Documentation(info="<html>
<p>
Enumeration to specify the calculation of the hydraulic efficiency.
See <a href=\"modelica://Buildings.Fluid.Movers.UsersGuide\">Buildings.Fluid.Movers.UsersGuide</a>
for instructions.
</p>
</html>", revisions="<html>
<ul>
<li>
October 15, 2021, by Hongxiang Fu:<br/>
First implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2668\">#2668</a>.
</li>
</ul>
</html>"));

  type MotorEfficiencyMethod = enumeration(
      NotProvided
        "Not provided, computed from other efficiency terms",
      Efficiency_VolumeFlowRate "Array of efficiency vs. volumetric flow rate",
      Efficiency_MotorPartLoadRatio
        "Rated input and array of efficiency vs. motor part load ratio yMot=WHyd/WMot_nominal",
      GenericCurve
        "Rated input and maximum efficiency to be used for generic curves")
    "Enumeration to choose the computation method for motor efficiency"
    annotation (Documentation(info="<html>
<p>
Enumeration to specify the calculation of the motor efficiency.
See <a href=\"modelica://Buildings.Fluid.Movers.UsersGuide\">Buildings.Fluid.Movers.UsersGuide</a>
for instructions.
</p>
</html>", revisions="<html>
<ul>
<li>
October 15, 2021, by Hongxiang Fu:<br/>
First implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2668\">#2668</a>.
</li>
</ul>
</html>"));

 annotation (preferredView="info", Documentation(info="<html>
<p>
This package contains type definitions for movers.
</p>
</html>"));
end Types;

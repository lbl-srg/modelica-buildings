within Buildings.Applications.DHC.Examples.Combined.Generation5.Unidirectional.Distribution.BaseClasses;
model PipeConnection "Building service connection pipe"
  extends Buildings.Fluid.FixedResistances.HydraulicDiameter(
    dp(nominal=1E5),
    dh=0,
    final fac=1.1,
    final ReC=6000,
    final linearized=false,
    final v_nominal=m_flow_nominal * 4 / (rho_default * dh^2 * Modelica.Constants.pi));
    // Steel straight pipe
    annotation (
    DefaultComponentName="pipCon",
    Icon(graphics={
        Rectangle(
          extent={{-100,22},{100,-24}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,140,72})}));
end PipeConnection;

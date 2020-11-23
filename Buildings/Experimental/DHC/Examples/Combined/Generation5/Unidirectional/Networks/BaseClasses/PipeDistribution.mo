within Buildings.Applications.DHC.Examples.Combined.Generation5.Unidirectional.Networks.BaseClasses;
model PipeDistribution "DHC distribution pipe"
  extends Buildings.Fluid.FixedResistances.HydraulicDiameter(
    dp(nominal=1E5),
    dh=0,
    final fac=1.1,
    final ReC=6000,
    final roughness=7E-6,
    final linearized=false,
    final v_nominal=m_flow_nominal * 4 / (rho_default * dh^2 * Modelica.Constants.pi));
    // PE100 straight pipe
equation
  when terminal() then
    if length > Modelica.Constants.eps then
      Modelica.Utilities.Streams.print(
         "Pipe nominal pressure drop per meter for '" + getInstanceName() + "' is " +
          String(integer( floor( dp_nominal / length + 0.5)))   + " Pa/m.");
    else
      Modelica.Utilities.Streams.print(
         "Zero pipe pressure drop for '" + getInstanceName() +
         "' as the pipe length is set to zero.");
    end if;
  end when;
  annotation (
  DefaultComponentName="pipDis",
  Icon(graphics={
        Rectangle(
          extent={{-100,22},{100,-24}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,140,72})}));
end PipeDistribution;

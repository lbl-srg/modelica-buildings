within Buildings.Experimental.DHC.Examples.Combined.Generation5.Unidirectional.Networks.BaseClasses;
model PipeDistribution
  "DHC distribution pipe"
  extends PipeConnection(
    fac=1.5,
    roughness=7E-6);
    // Roughness of PE100 straight pipe
    // TODO: The following yields
    // Error in flattened model: Index reduction failed
    // with OCT.
// equation
//    when terminal() then
//      if length > Modelica.Constants.eps then
//        Modelica.Utilities.Streams.print(
//         "Pipe nominal pressure drop for '" + getInstanceName() + "': " +
//          String(integer(floor(dp_nominal / length + 0.5))) +
//          " Pa/m, pipe diameter: " + String(integer(floor(dh * 100))/100) + " m.");
//      else
//        Modelica.Utilities.Streams.print(
//          "Pipe nominal pressure drop for '" + getInstanceName() +
//           "' as the pipe length is set to zero.");
//      end if;
//    end when;
annotation (
  DefaultComponentName="pipDis",
  Icon(graphics={
        Rectangle(
          extent={{-100,22},{100,-24}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,140,72})}));
end PipeDistribution;

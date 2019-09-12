within Buildings.Fluid.Geothermal.Borefields.BaseClasses.GroundResponse.Functions;
function GroundResponse
  extends Modelica.Icons.Function;

  input Real C;
  input Real G;
  input Boolean steadyStateInitial;
  input Modelica.SIunits.HeatFlowRate QBor_flow(displayUnit="W");
  input Modelica.SIunits.Temperature TExt_start(displayUnit="degC",
                                                nominal=300)
    "Far field ground temperature";
  output Modelica.SIunits.Temperature TBorWal(displayUnit="degC")
    "Bore wall temperature";

external "C" getGroundResponse(C, G, steadyStateInitial, QBor_flow, TExt_start, TBorWal)
 annotation (
   Include="#include <getGroundResponse.c>",
   IncludeDirectory="modelica://Buildings/Resources/C-Sources");

end GroundResponse;

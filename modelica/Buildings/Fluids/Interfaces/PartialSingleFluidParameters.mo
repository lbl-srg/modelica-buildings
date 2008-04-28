partial model PartialSingleFluidParameters 
  "Partial model with parameters that are shared by flow models" 
  import SI = Modelica.SIunits;
  import Modelica.Constants;
  replaceable package Medium = 
      Modelica.Media.Interfaces.PartialMedium "Medium in the component" 
                                                                       annotation (
      choicesAllMatching =                                                                            true);
  
 parameter Modelica_Fluid.Types.FlowDirection.Temp flowDirection=Modelica_Fluid.
       Types.FlowDirection.Bidirectional 
    "Unidirectional (port_a -> port_b) or bidirectional flow component" 
     annotation(Dialog(tab="Advanced"));
  
  annotation (
    Coordsys(grid=[1, 1], component=[20, 20]),
    Diagram,
    Documentation(info="<html>
<p>
This model contains parameters that are used by models that have one fluid.
</p>
</html>", revisions="<html>
<ul>
<li>
March 11, 2008, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"),
    Icon);
protected 
    parameter Boolean allowFlowReversal=
     flowDirection == Modelica_Fluid.Types.FlowDirection.Bidirectional 
    "= false, if flow only from port_a to port_b, otherwise reversing flow allowed"
     annotation(Evaluate=true, Hide=true);
end PartialSingleFluidParameters;

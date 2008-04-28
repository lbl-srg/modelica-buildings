partial model PartialDoubleFluidParameters 
  "Partial model with parameters that are shared by flow models" 
  import SI = Modelica.SIunits;
  import Modelica.Constants;
  
  replaceable package Medium_1 = Modelica.Media.Interfaces.PartialMedium 
    "Fluid 1"              annotation(choicesAllMatching, Dialog(tab="General",group="Fluid 1"));
  replaceable package Medium_2 = Modelica.Media.Interfaces.PartialMedium 
    "Fluid 2"              annotation(choicesAllMatching,Dialog(tab="General", group="Fluid 2"));
  
 parameter Modelica_Fluid.Types.FlowDirection.Temp flowDirection_1=
       Modelica_Fluid.Types.FlowDirection.Bidirectional 
    "Unidirectional (port_a -> port_b) or bidirectional flow component" 
     annotation(Dialog(tab="Advanced"));
 parameter Modelica_Fluid.Types.FlowDirection.Temp flowDirection_2=
       Modelica_Fluid.Types.FlowDirection.Bidirectional 
    "Unidirectional (port_a -> port_b) or bidirectional flow component" 
     annotation(Dialog(tab="Advanced"));
  
  annotation (
    Coordsys(grid=[1, 1], component=[20, 20]),
    Diagram,
    Documentation(info="<html>
<p>
This model contains parameters that are used by models that have two fluids.
</p>
</html>", revisions="<html>
<ul>
<li>
March 25, 2008, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"),
    Icon);
  
    parameter Boolean allowFlowReversal_1=
     flowDirection_1 == Modelica_Fluid.Types.FlowDirection.Bidirectional 
    "= false, if flow only from port_a to port_b, otherwise reversing flow allowed"
     annotation(Evaluate=true, Hide=true);
    parameter Boolean allowFlowReversal_2=
     flowDirection_2 == Modelica_Fluid.Types.FlowDirection.Bidirectional 
    "= false, if flow only from port_a to port_b, otherwise reversing flow allowed"
     annotation(Evaluate=true, Hide=true);
end PartialDoubleFluidParameters;

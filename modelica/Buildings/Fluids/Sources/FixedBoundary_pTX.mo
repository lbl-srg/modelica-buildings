model FixedBoundary_pTX 
  "Boundary pressure, temperature and mass fraction source" 
  extends Modelica_Fluid.Sources.FixedBoundary_pTX;
  annotation (Documentation(info="<html>
This model is used to add the auxiliary species flow, 
such as for modeling carbon dioxide transport, to the base
model. Otherwise, the model is identical to
<a href=\"Modelica:Modelica_Fluid.Sources.FixedBoundary_pTX\">
Modelica_Fluid.Sources.FixedBoundary_pTX</a>.
</html>", revisions="<html>
<ul>
<li>
September 18, 2008 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
equation 
 ///////////////////////////////////////////////////////////////////////////////////
 // Extra species flow. This may be removed when upgrading to the new Modelica.Fluid.  
 port.mC_flow = semiLinear(port.m_flow, port.C, 0);
 ///////////////////////////////////////////////////////////////////////////////////
end FixedBoundary_pTX;

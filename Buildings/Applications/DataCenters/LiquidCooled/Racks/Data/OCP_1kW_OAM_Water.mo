within Buildings.Applications.DataCenters.LiquidCooled.Racks.Data;
record OCP_1kW_OAM_Water
  "OpenCompute example for 1 kW OAM with DI water as working fluid"
  extends Generic_R_m_flow(
    V_flow={2.0, 3.0, 4.0, 5.0}/60/1000,
    R = {0.0172, 0.0160, 0.0154, 0.0151});
  annotation (
  defaultComponentName="datTheRes",
  defaultComponentPrefixes="parameter",
  Documentation(info="<html>
<p>
This specification is for a 1 kW Open Accelerator Module (OAM) based on the Open Compute Project (OCP)
report by Cheng et al. (2023).
The data is based on Figure 8, which is for a single cold plate with deionized (DI) water as the working fluid.
</p>
<h4>References</h4>
<p>
Cheng Chen, Dennis Trieu, Tejas Shah, Allen Guo, Jaylen Cheng, Christopher Chapman, Sukhvinder Kang,
Eran Dagan, Assaf Dinstag,Jane Yao.
<a href=\"https://www.opencompute.org/documents/oai-system-liquid-cooling-guidelines-in-ocp-template-mar-3-2023-update-pdf\">
OCP OAI SYSTEM LIQUID COOLING GUIDELINES</a>.
2023.
<p>
</html>", revisions="<html>
<ul>
<li>
December 16, 2025, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end OCP_1kW_OAM_Water;

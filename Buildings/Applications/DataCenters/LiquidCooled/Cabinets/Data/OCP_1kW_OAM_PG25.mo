within Buildings.Applications.DataCenters.LiquidCooled.Cabinets.Data;
record OCP_1kW_OAM_PG25 "OpenCompute example for 1 kW OAM with PG25 as working fluid"
  extends Generic_R_m_flow(
    V_flow={0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0, 1.2, 1.4, 1.6, 1.8, 2.0, 2.2, 2.4},
    R = 1E-3/60*{0.0389, 0.0325, 0.0300, 0.0280, 0.0265, 0.0255, 0.0245, 0.0230, 0.0220, 0.0214, 0.0209, 0.0204, 0.0200, 0.0197},
    d = 1005);
  annotation (
  defaultComponentName="datRes",
  defaultComponentPrefixes="parameter",
  Documentation(info="<html>
<p>
This specification is for a 1 kW Open Accelerator Module (OAM) based on the Open Compute Project (OCP)
report by Cheng et al. (2023).
The data is based on Figure 7, which is for a single cold plate with PG25 as the working fluid.
</p>
<h4>References</h4>
<p>
Cheng Chen, Dennis Trieu, Tejas Shah, Allen Guo, Jaylen Cheng, Christopher Chapman, Sukhvinder Kang,
Eran Dagan, Assaf Dinstag,Jane Yao.
<a href=\"https://www.opencompute.org/documents/oai-system-liquid-cooling-guidelines-in-ocp-template-mar-3-2023-update-pdf\">
OCP OAI SYSTEM LIQUID COOLING GUIDELINES</a>.
2023.
<p>
</html>"));
end OCP_1kW_OAM_PG25;

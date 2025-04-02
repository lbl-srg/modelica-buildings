within Buildings.Fluid.Movers.Data.Pumps;
record BoilerPlant "Pump curves for BoilerPlant model in Examples package"
  extends Generic(
    use_powerCharacteristic=true,
    speed_rpm_nominal=1450,
    power(V_flow={0, 0.11345, 0.2269}, P={0, 7.5*28985.04, 7.5*57970.08}),
    pressure(V_flow={0, 0.11345, 0.2269}, dp={70000,35000,0}));
  annotation (
defaultComponentPrefixes="parameter",
defaultComponentName="per",
Documentation(info="<html>
<p>Pump curves generated using sizing parameters derived from EnergyPlus prototype
model for large office building.</p>
</html>",   revisions="<html>
<ul>
<li>
October 12, 2021, by Karthik Devaprasad:
<br/>
First added to Buildings library.
</li>
</ul>
</html>"));
end BoilerPlant;

within Buildings.Templates.BaseClasses.Controls.AHUs;
partial block SingleDuct "Base class for controllers of single duct AHU"
  extends Templates.Interfaces.ControllerAHU;

  outer replaceable Templates.BaseClasses.OutdoorReliefReturnSection.HeatRecovery secOutRel
    "Outdoor/relief/return air section";

  outer replaceable Templates.BaseClasses.Coils.None coiCoo
    "Cooling coil";
  outer replaceable Templates.BaseClasses.Coils.None coiHea
    "Heating coil";
  outer replaceable Templates.BaseClasses.Coils.None coiReh
    "Reheat coil";

  outer replaceable Templates.BaseClasses.Fans.None fanSupDra
    "Supply fan - Draw through";
  outer replaceable Templates.BaseClasses.Fans.None fanSupBlo
    "Supply fan - Blow through";

  final inner parameter Templates.Types.Fan typFanSup=
    if fanSupDra.typ <> Templates.Types.Fan.None then fanSupDra.typ
    elseif fanSupBlo.typ <> Templates.Types.Fan.None then fanSupBlo.typ
    else Templates.Types.Fan.None
    "Type of supply fan"
    annotation (Evaluate=true);
  final inner parameter Templates.Types.Fan typFanRet = secOutRel.secRel.typFan
    "Type of return fan"
    annotation (Evaluate=true);

  annotation (Documentation(info="<html>
<p>
The outer compenent declarations reference a base class rather
than the interface.
This is because the controllers may need to access inside components
that are not declared in the interface class (which only provides the 
connectors).
So we would typically get warnings like:
</p>
<p>
<code>
Access to component secRel not recommended, it is not present in constraining 
type of declaration 'inner replaceable Templates.BaseClasses.OutdoorReliefReturnSection.Economizer 
secOutRel constrainedby Templates.Interfaces.OutdoorReliefReturnSection 
(final redeclare package MediumAir = MediumAir)'
</code>
</p>
</html>"));
end SingleDuct;

within Buildings.OpenStudioToModelica.PrototypeBuilding.Examples;
model RenewablesSourcesDR
  extends RenewableSources(
    bui1(useDeltaTSP=false),
    bui2(useDeltaTSP=false),
    bui3(useDeltaTSP=false),
    bui4(useDeltaTSP=false),
    bui5(useDeltaTSP=false),
    bui6(useDeltaTSP=false),
    bui7(useDeltaTSP=false));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-120,
            -100},{380,100}})));
end RenewablesSourcesDR;

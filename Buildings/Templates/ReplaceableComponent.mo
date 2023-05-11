within Buildings.Templates;
model ReplaceableComponent
  extends Modelica.Icons.Example;

  partial model InterfaceComponent
    replaceable SubComponentOption1 sub
      annotation(choices(
      choice(redeclare SubComponentOption1 sub),
      choice(redeclare SubComponentOption2 sub)));
  end InterfaceComponent;

  model ComponentOption1
    extends InterfaceComponent;
  end ComponentOption1;

  model ComponentOption2
    extends InterfaceComponent(redeclare final SubComponentOption2 sub);
  end ComponentOption2;

  model SubComponentOption1
    parameter Integer flag=1;
  end SubComponentOption1;

  model SubComponentOption2
    parameter Integer flag=2;
  end SubComponentOption2;

  model Template
    replaceable ComponentOption1 comp constrainedby InterfaceComponent
    annotation(choices(
    choice(redeclare ComponentOption1 comp),
    choice(redeclare ComponentOption2 comp)));
  end Template;

  model TemplateOption1
    extends Template(
      comp(redeclare SubComponentOption1 sub));
  end TemplateOption1;

  TemplateOption1 template(redeclare ComponentOption2 comp)
    annotation(Dialog(group="Test"));
end ReplaceableComponent;

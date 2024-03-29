import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:student_canteens/models/City.dart';
import 'package:student_canteens/models/SCUser.dart';
import 'package:student_canteens/services/AuthService.dart';
import 'package:student_canteens/services/GCF.dart';
import 'package:student_canteens/services/SessionManager.dart';
import 'package:student_canteens/utils/TimeOfDayExtension.dart';
import 'package:student_canteens/utils/utils.dart';
import 'package:collection/collection.dart';

class EditProfileView extends StatefulWidget {
  final Function parentRefreshWidget;

  const EditProfileView({Key? key, required this.parentRefreshWidget})
      : super(key: key);

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final AuthService authService = AuthService.sharedInstance;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final GCF gcf = GCF.sharedInstance;
  final SessionManager sessionManager = SessionManager.sharedInstance;

  String name = "";
  String surname = "";
  String email = "";
  City? selectedCity;
  TimeOfDay? lunchTime;
  bool notificationsOn = false;

  String? nameError;
  String? surnameError;
  String? emailError;

  SCUser? currentUser;
  String? profileImageUrl;
  Set<City> cities = {};
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    updateWidget(() {
      isLoading = true;
    });

    currentUser = sessionManager.currentUser;
    profileImageUrl = firebaseAuth.currentUser?.photoURL;

    updateWidget(() {
      name = currentUser?.name ?? "";
      surname = currentUser?.surname ?? "";
      email = currentUser?.email ?? "";
      lunchTime = currentUser?.lunchTime;
      notificationsOn = currentUser?.lunchTime != null;
    });

    getCities().then((value) {
      updateWidget(() {
        cities = value;
        selectedCity = cities
            .firstWhereOrNull((element) => element.name == currentUser?.city);
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: CustomScrollView(
        slivers: [
          // app bar
          SliverAppBar.medium(
            centerTitle: true,
            surfaceTintColor: Colors.grey[900],
            title: const Text(
              "Uredi profil",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),

          // loading indicator
          SliverVisibility(
            visible: isLoading,
            sliver: const SliverFillRemaining(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),

          // content
          SliverVisibility(
            visible: !isLoading,
            sliver: SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: SizedBox(
                        height: 100,
                        width: 100,
                        child: CircleAvatar(
                          backgroundColor: Colors.grey[300],
                          backgroundImage: profileImageUrl != null
                              ? NetworkImage(profileImageUrl!)
                              : null,
                          child: profileImageUrl == null
                              ? Text(
                                  currentUser?.getInitials() ?? "",
                                  style: TextStyle(
                                    color: Colors.grey[900],
                                    fontFamily: "",
                                    fontSize: 22,
                                  ),
                                )
                              : null,
                        ),
                      ),
                    ),
                    TextFormField(
                      initialValue: name,
                      onChanged: (value) {
                        updateWidget(() {
                          name = value;
                        });
                      },
                      cursorColor: Colors.grey[900],
                      decoration: InputDecoration(
                        labelText: "Ime",
                        errorText: nameError,
                        labelStyle: const TextStyle(color: Colors.grey),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade900),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      initialValue: surname,
                      onChanged: (value) {
                        updateWidget(() {
                          surname = value;
                        });
                      },
                      cursorColor: Colors.grey[900],
                      decoration: InputDecoration(
                        labelText: "Prezime",
                        errorText: surnameError,
                        labelStyle: const TextStyle(color: Colors.grey),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade900),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      enabled: false,
                      readOnly: true,
                      initialValue: email,
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Wrap(
                      direction: Axis.horizontal,
                      alignment: WrapAlignment.start,
                      children: [
                        SizedBox(
                          height: 50,
                          child: DropdownButton(
                            underline: const SizedBox(
                              height: 2,
                              child: Divider(
                                color: Colors.grey,
                              ),
                            ),
                            focusColor: Colors.white,
                            isExpanded: false,
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                            ),
                            iconSize: 26,
                            value: selectedCity,
                            hint: const Text(
                              "Odaberi grad u kojem studiraš",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                            items: cities.map((e) {
                              return DropdownMenuItem(
                                value: e,
                                child: Text(e.name),
                              );
                            }).toList(),
                            onChanged: (value) {
                              updateWidget(() {
                                selectedCity = value as City;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          onPressed: () {
                            Utils.showAlertDialog(
                              context,
                              "Grad u kojem studiraš",
                              """Ova informacija se koristi kako bismo ti mogli slati razne obavijesti o menzama u tvojem gradu.""",
                            );
                          },
                          icon: Icon(
                            Icons.info_outline_rounded,
                            size: 20,
                            color: Colors.blue[200],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Wrap(
                      direction: Axis.horizontal,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      // spacing: 16,
                      children: [
                        Text(
                          "Obavijesti",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[900],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Switch(
                          value: notificationsOn,
                          onChanged: switchChanged,
                        ),
                        IconButton(
                          onPressed: () {
                            Utils.showAlertDialog(
                              context,
                              "Obavijesti",
                              "Obavijesti ti šaljemo svakog dana u vrijeme ručka kako bi znao/la u kojoj menzi je najmanja gužva. (Ova opcija je trenutno dostupna samo na Android uređajima).",
                            );
                          },
                          icon: Icon(
                            Icons.info_outline_rounded,
                            size: 20,
                            color: Colors.blue[200],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Visibility(
                      visible: notificationsOn,
                      child: Wrap(
                        direction: Axis.horizontal,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                            "Vrijeme ručka: ",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[900],
                            ),
                          ),
                          TextButton(
                            onPressed:
                                notificationsOn ? showLunchTimePicker : null,
                            child: Text(
                              lunchTime != null
                                  ? lunchTime!.toString().substring(10, 15)
                                  : "Odaberi",
                              style: TextStyle(
                                fontSize: 18,
                                color: notificationsOn
                                    ? Colors.blue
                                    : Colors.blue[200],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Center(
                      child: ElevatedButton(
                        onPressed: isSaveButtonEnabled ? updateUser : null,
                        child: const Text("Spremi"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void updateWidget(void Function() callback) {
    if (!mounted) return;
    setState(callback);
  }

  Future<Set<City>> getCities() async {
    return gcf.getCanteenCities();
  }

  bool get isSaveButtonEnabled {
    return name != currentUser?.name ||
        surname != currentUser?.surname ||
        email != currentUser?.email ||
        selectedCity?.name != currentUser?.city ||
        lunchTime != currentUser?.lunchTime;
  }

  bool validateInput() {
    updateWidget(() {
      nameError = name.isEmpty ? "Potrebno ime" : null;
      surnameError = surname.isEmpty ? "Potrebno prezime" : null;
      emailError = email.isEmpty ? "Potrebna email adresa" : null;
    });

    if (selectedCity == null) {
      Utils.showAlertDialog(context, "Greška", "Potrebno odabrati grad");
    }

    return nameError == null &&
        surnameError == null &&
        emailError == null &&
        selectedCity != null;
  }

  void updateUser() async {
    Utils.showLoadingDialog(context);

    if (email != currentUser?.email) {
      await authService.updateUserEmail(email);
    }

    if (name != currentUser?.name ||
        surname != currentUser?.surname ||
        selectedCity?.name != currentUser?.city ||
        lunchTime != currentUser?.lunchTime) {
      bool result = await authService.updateUser(
        SCUser(
          id: currentUser?.id,
          name: name,
          surname: surname,
          email: email,
          city: selectedCity?.id.toString(),
          lunchTime: lunchTime,
        ),
      );

      if (result) {
        updateWidget(() {
          currentUser = sessionManager.currentUser;
          name = currentUser?.name ?? "";
          surname = currentUser?.surname ?? "";
          email = currentUser?.email ?? "";
          selectedCity =
              cities.firstWhere((element) => element.name == currentUser?.city);
          lunchTime = currentUser?.lunchTime;
          widget.parentRefreshWidget();
        });
        Utils.showSnackBarMessage(context, "Uspješno ažuriran profil");
      } else {
        Utils.showSnackBarMessage(context, "Greška");
      }
    }

    Navigator.pop(context);
  }

  void showLunchTimePicker() async {
    TimeOfDay? selectedLunchTime = await showTimePicker(
      context: context,
      initialTime:
          currentUser?.lunchTime ?? const TimeOfDay(hour: 12, minute: 0),
    );

    if (selectedLunchTime != null) {
      if (selectedLunchTime.isBefore(const TimeOfDay(hour: 11, minute: 0)) ||
          selectedLunchTime.isAfter(const TimeOfDay(hour: 18, minute: 0))) {
        Utils.showAlertDialog(
          context,
          "Greška",
          "Vrijeme ručka mora biti između 11:00 i 18:00",
        );
      } else {
        updateWidget(() {
          lunchTime = selectedLunchTime;
        });
      }
    }
  }

  void switchChanged(bool value) {
    updateWidget(() {
      notificationsOn = value;
      lunchTime = value ? currentUser?.lunchTime : null;
    });
  }
}

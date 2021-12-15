package com.example.newslist;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;


public class LoginActivity extends AppCompatActivity {

    private String saisieLogin;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_login);
        setTitle(getLocalClassName());

        // Bouton login
        Button boutonLogin = (Button) findViewById(R.id.bouton_login);

        // Zone saisie de texte
        EditText saisie_login = (EditText) findViewById(R.id.saisie_login);

        // Déclaration future activité
        Intent intent = new Intent(this, NewsActivity.class);

        boutonLogin.setOnClickListener(new View.OnClickListener() {

            @Override
            public void onClick(View view) {

                // toast
                saisieLogin = saisie_login.getText().toString();
                Toast toast = Toast.makeText(LoginActivity.this, "On part vers News Activity!", Toast.LENGTH_SHORT);
                toast.show();

                // Transmission login et lancement activité suivante
                intent.putExtra("login", saisieLogin);
                startActivity(intent); // Lancement activité

                // fermeture de l'activité actuelle
                finish(); // Clore l'activité actuel
            }
        });
    }

    @Override
    public void onBackPressed() {
        super.onBackPressed();

        // toast
        Toast toast = Toast.makeText(LoginActivity.this, "On revient à l'acceuil", Toast.LENGTH_SHORT);
        toast.show();

        // fermeture de l'activité actuelle
        finish(); // Clore l'activité actuel
    }
}
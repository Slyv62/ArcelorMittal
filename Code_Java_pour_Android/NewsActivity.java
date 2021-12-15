package com.example.newslist;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;
import android.widget.Toast;

public class NewsActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_news);
        setTitle(getLocalClassName());

        // Déclaration contexte
        NewsListApplication app = (NewsListApplication) getApplicationContext();

        // Extra - récupération du mot de pass
        Intent intent = getIntent();
        String leLogin="";
        if (intent.hasExtra("login")) {
            leLogin = "Login = "+ intent.getStringExtra("login");
        }
        else{
            leLogin=app.getLogin();
        }

        // Chargement du login dans le contexte
        app.setLogin(leLogin);

        // Affichage du login
        TextView affichageLogin = (TextView) findViewById(R.id.login);
        affichageLogin.setText(leLogin);

        // Déclaration des 2 boutons
        Button boutonDetails = (Button) findViewById(R.id.bouton_details);
        Button boutonLogout = (Button) findViewById(R.id.bouton_logout);

        // Déclaration des 2 futures activités Login et Details
        Intent intentLoginActivity = new Intent(this, LoginActivity.class);
        Intent intentDetailsActivity = new Intent(this, DetailsActivity.class);

        boutonDetails.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

                // Toast
                Toast toast = Toast.makeText(NewsActivity.this, "On part vers Details Activity!", Toast.LENGTH_SHORT);
                toast.show();

                // lancement activité suivante
                startActivity(intentDetailsActivity);

                // fermeture de l'activité actuelle
                finish(); // Clore l'activité actuel
            }
         });

        boutonLogout.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

                // Toast
                Toast toast = Toast.makeText( NewsActivity.this, "On part vers Login Activity!", Toast.LENGTH_SHORT);
                toast.show();

                // lancement activité suivante
                startActivity(intentLoginActivity);

                // fermeture de l'activité actuelle
                finish(); // Clore l'activité actuel
            }
        });
    }

    @Override
    public void onBackPressed() {
        super.onBackPressed();
        Toast toast = Toast.makeText(NewsActivity.this, "On revient à l'acceuil", Toast.LENGTH_SHORT);
        toast.show();
        finish(); // Clore l'activité actuel
    }
}

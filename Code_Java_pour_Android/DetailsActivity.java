package com.example.newslist;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;
import android.widget.Toast;

public class DetailsActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_details);
        setTitle(getLocalClassName());

        // Déclaration des 2 boutons
        Button boutonOk = (Button) findViewById(R.id.bouton_ok);
        Button boutonNews = (Button) findViewById(R.id.bouton_news);

        // Déclaration contexte
        NewsListApplication app = (NewsListApplication) getApplicationContext();
        // Récupération Login du contexte
        String monLogin = app.getLogin();
        // Affichage Login
        TextView affichageLogin = (TextView) findViewById(R.id.Text_login);
        affichageLogin.setText(monLogin);

        // Déclaration future Intent - Devrais être en ligne 45 mais cela ne fonctionne pas. ?
        Intent intent = new Intent(this, NewsActivity.class);

        boutonOk.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

                // Toast
                Toast toast = Toast.makeText(DetailsActivity.this, "On reviens vers News Activity!", Toast.LENGTH_SHORT);
                toast.show();

                // Déclaration et lancement de la future activité
                // Intent intent = new Intent(this, NewsActivity.class);
                startActivity(intent); // Lancement activité

                // Fermeture activité actuelle
                finish(); // Clore l'activité actuel
            }
        });

        boutonNews.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
;

                // Toast
                Toast toast = Toast.makeText(DetailsActivity.this, "On affiche les informations de google", Toast.LENGTH_SHORT);
                toast.show();

                // lancement activité afficher une page web
                String url = "https://news.google.com/";
                Intent intent = new Intent(Intent.ACTION_VIEW, Uri.parse(url));
                startActivity(intent);

                // Fermeture activité actuelle
                finish(); // Clore l'activité actuel
            }
        });

    }

    @Override
    public void onBackPressed() {
        super.onBackPressed();

        // Toast
        Toast toast = Toast.makeText(DetailsActivity.this, "On reviens vers News Activity!", Toast.LENGTH_SHORT);
        toast.show();

        // Lancement future activité NewsActivity
        Intent intent = new Intent(this, NewsActivity.class);
        startActivity(intent); // Lancement activité

        // Fermeture de l'activité actuelle
        finish(); // Clore l'activité actuelle
    }
}